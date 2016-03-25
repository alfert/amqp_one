defmodule AmqpOne.Transport do

  @moduledoc """
  Implements the transport layer of AMQP. For the server side,
  we use Ranch as TCP connection pool. We follow the `gen_server`
  example for Ranch's protocole (see http://ninenines.eu/docs/en/ranch/1.1/guide/protocols/).

  Open Issues:
  * encoding and decoding the frames properly
  * what to to with the open frame?
  """
  use GenServer
  require Logger
  alias AmqpOne.Transport.Socket

  @type perf_t :: :open | :begin | :attach | :flow | :transfer |
  :disposition | :detch | :end | :close

  @type conn_state_t :: :start | :hdr_rcvd | :hdr_sent | :open_rcvd |
    :open_sent | :opened | :open_pipe | :oc_pipe | :close_pipe |
    :close_sent | :close_rcvd | :end | :hdr_exch | :waiting

  @typedoc "The connection reference"
  @opaque conn_t :: pid

  @amqp_header <<"AMQP", 0, 1, 0, 0>>

  defmodule Frame, do: defstruct performative: :close, channel: 0, payload: ""

  defstruct host: "localhost",
    port: 5672,
    options: [],
    socket_mod: AmqpOne.Transport.TcpSocket,
    socket: nil,
    state: :start

  @type t :: %__MODULE__{host: :inet.ip_address | :inet.hostname,
    port: :inet.port_number,
    options: :gen_tcp.connect_option,
    socket_mod: atom,
    socket: nil | :inet.socket,
    state: conn_state_t
  }

  @doc """
  Opens a new connection. Parameters `host` and `port` are
  as expected, `options` contain all `:gen_tcp` options. Finally,
  there is the module for creating the socket, per default this
  is `TcpSocket`.

  We set here a couple of options, required for proper handling
  of the TCP connection:

  * `ative:` is set to `once`, i.e. only one received package
    is sent to the process.
  * `packet:`is set to `4`, this means every package has a 4 four
    length field (for reading and writing)
  """
  @spec open(:inet.ip_address | :inet.hostname, :inet.port_number,
    :gen_tcp.connect_option, atom) :: {:ok, conn_t} | {:error, any}
  def open(host, port, options, socket_mod \\ AmqpOne.Transport.TCPSocket)
  def open(host, port, options, socket_mod) when is_binary(host), do:
    open(String.to_char_list(host), port, options, socket_mod)
  def open(host, port, options, socket_mod) do
    # Options active and packet are set after the first received data
    opts = options
    |> Keyword.put(:active, false)
    |> Keyword.put(:packet, 0)
    {:ok, pid} = GenServer.start_link(__MODULE__, [host, port, [:binary | opts], socket_mod], [])
    GenServer.call(pid, {:connect})
  end

  @spec close(conn_t) :: :ok
  def close(conn) do
    GenServer.call(conn, {:close})
  end

  @doc """
  Encodes the internal representation of a frame to a proper
  binary encoded AMQP 1.0 frame
  """
  @spec encode_frame(%Frame{}) :: binary
  def encode_frame(%Frame{} = frame) do
    :erlang.term_to_binary(frame)
  end

  @doc """
  Decodes a proper binary encoded AMQP 1.0 frame to the internal representation
  of a frame.
  """
  @spec decode_frame(%Frame{}) :: binary
  def decode_frame(bin_frame) when is_binary(bin_frame) do
    :erlang.binary_to_term(bin_frame)
  end


  @doc false
  def init([host, port, options, socket_mod]) do
    state = %__MODULE__{host: host, port: port, options: options,
        socket_mod: socket_mod, state: :start}
    Logger.info "init([..]): state = #{inspect state}"
    {:ok, state}
  end

  @doc false
  # start link for Ranch Listener
  def start_link(ref, socket, transport, opts) do
    options = opts
    |> Keyword.put(:active, false)
    |> Keyword.put(:packet, 0)
    :proc_lib.start_link(__MODULE__, :init, [ref, socket, transport, options])
  end

  @doc false
  # init for Ranch Listener
  def init(ref, socket, transport, opts) do
    :ok = :proc_lib.init_ack({:ok, self})
    # Perform any required state initialization here.
    :ok = :ranch.accept_ack(ref)
    :ok = transport.setopts(socket, [active: false])
    {:ok, {host, port}} = :inet.sockname(socket)
    {:ok, state} = init([host, port, opts, transport])
    new_state = %__MODULE__{state | socket: socket}
    Logger.info "init(..,..,): state = #{inspect new_state}"
    case transport.recv(socket, 8, 5_000) do
      {:ok, @amqp_header} ->
            :ok = transport.send(socket, @amqp_header)
            :inet.setopts(socket, [active: :once, packet: 4])
            :gen_server.enter_loop(__MODULE__, [], %__MODULE__{new_state| state: :hdr_exch})
      _ -> transport.close(socket)
    end

  end

  @doc false
  def handle_call({:connect}, _from, state = %__MODULE__{state: :start}) do
    Logger.info "connect in state #{inspect state}"
    socket_mod = state.socket_mod
    {:ok, s} = socket_mod.connect(state.host, state.port, state.options)
    :ok = Socket.send(s, @amqp_header)
    Logger.info "connect: sent the header, now receiving the header"
    {:ok, @amqp_header} = Socket.recv(s, 8)
    Socket.set_opts(s, [packet: 4, active: :once])
    Logger.info "connect: got header"
    {:reply, :ok, %__MODULE__{state | socket: s, state: :hdr_exch}}
  end
  def handle_call({:close}, _from, state) do
    s = connection(state.state, %Frame{performative: :close}, state)
    {:stop, :normal, :ok, s}
  end

  # handle all messages from the tcp layer
  @doc false
  def handle_info({:tcp, socket, data}, state) do
    Logger.info "handle_info: at #{inspect state}"
    ^socket = state.socket
    new_state = connection(state.state, {:tcp, decode_frame(data)}, state)
    Logger.info "handle_info: from #{state.state} to #{new_state.state}"
    AmqpOne.Transport.Socket.set_active_once(state.socket)
    {:no_reply, new_state}
  end

  @spec connection(conn_state_t, binary | %Frame{}, t) :: t
  def connection(:start, {tcp, @amqp_header}, state) do
    # this state is only relevant for being a server.
    # there is no attempt to deal with this situation for now.
    Socket.set_active_once(state.socket)
    put_in(state, :state, :hdr_rcvd)
  end
  def connection(:hdr_sent, %Frame{performative: :open} = f, state) do
    # we are sending an open directly after the hdr: pipelining!
    AmqpOne.Transport.Socket.send(state.socket, encode_frame(f))
    put_in state, :state, :open_pipe
  end
  def connection(:hdr_sent, @amqp_header, state) do
    # we are compatible with the server, nice!
    AmqpOne.Transport.Socket.set_active_once(state.socket)
    put_in state, :state, :hdr_exch
  end
  def connection(:hdr_rcvd, {:tcp, header = @amqp_header}, state) do
    # this is currently a server state, our connection functions does
    # not allow this situation. Not tested!
    :ok = AmqpOne.Transport.Socket.send(state.socket, header)
    AmqpOne.Transport.Socket.set_opts(state.socket, packet: 4)
    AmqpOne.Transport.Socket.set_active_once(state.socket)
    put_in state, :state, :hdr_exch
  end
  def connection(:hdr_exch, %Frame{performative: :open} = f, state) do
    :ok = AmqpOne.Transport.Socket.send(state.socket, encode_frame(f))
    put_in state, :state, :open_sent
  end
  def connection(:hdr_exch, {:tcp, %Frame{performative: :open} = f}, state) do
    Logger.info "Got an open frame: #{inspect f}"
    put_in state, :state, :open_rcvd
  end
  def connection(:open_rcvd, %Frame{performative: :open} = f, state) do
    :ok = AmqpOne.Transport.Socket.send(state.socket, encode_frame(f))
    put_in state, :state, :opened
  end
  def connection(:open_sent, {:tcp, %Frame{performative: :open} = f}, state) do
    Logger.info "Got an open frame: #{inspect f}"
    put_in state, :state, :opened
  end
  def connection(:open_sent, %Frame{performative: :close} = f, state) do
    Logger.info "Got an internal close frame: #{inspect f}"
    put_in state, :state, :close_pipe
  end
  def connection(:opened, %Frame{performative: :close} = f, state) do
    Logger.info "Got an internal close frame: #{inspect f}"
    put_in state, :state, :close_sent
  end
  def connection(:open_sent, {:tcp, %Frame{performative: :close} = f}, state) do
    Logger.info "Got an close frame: #{inspect f}"
    put_in state, :state, :close_rcvd
  end
  def connection(:opened, some_frame, state) do
    Logger.info "Got any AMQP frame: #{inspect some_frame}"
    Logger.error "We shoudl send this frame to someone else"
    state
  end
  def connection(:close_sent, {:tcp, %Frame{performative: :close} = f}, state) do
    AmqpOne.Transport.Socket.close(state.socket)
    put_in state, :state, :end
  end
  def connection(:close_rcvd, %Frame{performative: :close} = f, state) do
    AmqpOne.Transport.Socket.close(state.socket)
    put_in state, :state, :end
  end
  def conncetion(:open_pipe, %Frame{performative: :close} = f, state) do
    put_in state, :state, :oc_pipe
  end
  def conncetion(:open_pipe, @amqp_header, state) do
    put_in state, :state, :open_sent
  end
  def conncetion(:close_pipe, {:tcp, %Frame{performative: :open} = f}, state) do
    Logger.info "Got an open frame: #{inspect f}"
    put_in state, :state, :close_sent
  end


  defprotocol Socket do
    @moduledoc """
    Implements a layer around `:gen_tcp` to ease exchanging different
    socket implementations, in particular for testing purposes without
    network.

    This implementation uses `active: once`, such that one package
    is sent as an Erlang message to the owner process. After that,
    the socket becomes passive and must be set with `set_active(socket)`
    again back to `active: once`.

    For `active: :once` it is required that the implementation sends
    messages to the owning process following the `:gen_tcp` protocol.

    The client part starts with a call to open, which is not part
    of the protocol.

          def connect(address, port, options)
    """
    def send(socket, data)
    def set_active_once(socket)
    def recv(socket, length, timeout \\ :infinity)
    def close(socket)
    def set_opts(sockets, opts)
  end

  defmodule TCPSocket do
    @moduledoc """
    Implements the `Socket` protocoll for `:gen_tcp` sockets, i.e.
    for ports.
    """
    def connect(address, port, options) do
      :gen_tcp.connect(address, port, options)
    end

    defimpl Socket, for: Port do

      defdelegate send(s, data), to: :gen_tcp
      defdelegate recv(s, l), to: :gen_tcp
      defdelegate recv(s, l, timeout), to: :gen_tcp
      defdelegate close(s), to: :gen_tcp

      def set_active_once(s) do
        :inet.setopts(s, active: :once)
      end
      def set_opts(s, opts), do: :inet.setopts(s, opts)
    end

  end

end
