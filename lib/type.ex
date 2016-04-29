defmodule AmqpOne.TypeManager.Type, do: defstruct [:name, :class, :label, :encodings,
    :doc, :fields, :choices, :descriptor, :source, provides: [] ]
defmodule AmqpOne.TypeManager.Encoding, do: defstruct [:name, :code, :category, :label, :width]
defmodule AmqpOne.TypeManager.Descriptor, do: defstruct [:name, :code]
defmodule AmqpOne.TypeManager.Field, do:
  defstruct [:name, :type, :default, :label, mandatory: false,
    multiple: false, requires: []]
defmodule AmqpOne.TypeManager.Choice, do: defstruct [:name, :value, :doc]

defmodule AmqpOne.TypeManager do

  @moduledoc """
  Manages type specifications.

  You can add types and query types. All predefined types
  are handled directly, user definied types are stored in
  an ETS table.
  """

  alias AmqpOne.TypeManager.XML
  require AmqpOne.TypeManager.XML
  alias AmqpOne.TypeManager.{Type, Field, Descriptor, Encoding, Choice}
  require Logger

  @type class_t :: :primitive | :composite | :restricted | :union
  @type category_t :: :fixed | :variable | :compound | :array

  defstruct [:type_store, :struct_store]
  @type_ets_name AmqpOne.TypeManager.Types
  @struct_ets_name AmqpOne.TypeManager.Structs


  @doc """
  The type specification for the standard types as specified in the xml spec
  of the AMQP 1.0 standard.
  """
  @spec type_spec(String.t) :: Type.t | nil
  # Generate the primitives types
  XML.typespec AmqpOne.TypeManager.XML.xml_spec()
  # this must always be the last resort: We do not find a type and return nil
  def type_spec(%{__struct__: name}) do
    case :ets.lookup(@type_ets_name, name) do
      [] -> nil
      [{^name, type}] -> type
    end
  end
  def type_spec(name) do
    case :ets.lookup(@type_ets_name, name) do
      [] -> nil
      [{^name, type}] -> type
    end
  end

  @doc """
  Identifies the struct for the (complex) type, if it is registered
  with the type.
  """
  @spec struct_for_type(Type.t) :: %{__struct__: atom} | nil
  def struct_for_type(type) do
    case :ets.lookup(@struct_ets_name, type) do
      [] -> nil
      [{^type, struct}] -> struct
    end
  end


  def start_link() do
    ret_val = Agent.start_link(fn() ->
      # use ETS default options: set, key on position 1, protected
      %__MODULE__{
        type_store: :ets.new(@type_ets_name, [:named_table]),
        struct_store: :ets.new(@struct_ets_name, [:named_table])
        } end,
        name: __MODULE__)
    add_frame_types()
    ret_val
  end

  def stop() do
    Agent.stop(__MODULE__, :normal)
  end

  @doc """
  Adds a type with an explicit name. For structs, the struct and the type
  are also registered in the struct store.
  """
  def add_type(%{__struct__: name} = s, %Type{} = t) do
    #Logger.info "add struct #{name} = #{inspect s} for type #{t.name}"
    Agent.get(__MODULE__, fn(%__MODULE__{type_store: ts, struct_store: ss}) ->
      true = :ets.insert(ts, {name, t})
      true = :ets.insert(ss, {t, s})
    end)
  end
  def add_type(name, %Type{} = t) do
    #Logger.info "add with #{name} the type #{t.name}"
    Agent.get(__MODULE__, fn(%__MODULE__{type_store: ts}) ->
      true = :ets.insert(ts, {name, t})
    end)
  end

  @doc """
  Adds a type with the name(s) implicitely given in the type specification
  """
  def add_type(%Type{} = t) do
    Agent.get(__MODULE__, fn(%__MODULE__{type_store: ts}) ->
      get_names(t)
      |> Enum.each(fn name -> true = :ets.insert(ts, {name, t}) end)
      add_provides_types(t, ts)
    end)
  end

  defp get_names(%Type{} = t) do
    case t.descriptor do
      nil -> [t.name]
      [%Descriptor{name: n, code: c}] -> [n, c]
    end
  end

  defp add_provides_types(%Type{provides: provides} = t, type_store) do
    provides
    |> Enum.each(fn(p) ->
      case type_spec(p) do
        nil -> true = :ets.insert(type_store, {p, [t]})
        l when is_list(l) -> true = :ets.insert(type_store, {p, [t | l]})
        %Type{} = t1 -> Logger.error "Type #{p} is already present ignoring"
      end
    end)
  end

  @doc """
  Adds all required frame type to the type manager. This function
  must be called during startup of the type manager.
  """
  def add_frame_types() do
    AmqpOne.Transport.Frame.init()
  end

end
