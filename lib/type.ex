defmodule AmqpOne.TypeManager.Type, do: defstruct [:name, :class, :provides, :label, :encodings,
    :doc, :fields, :choices, :descriptor, :source]
defmodule AmqpOne.TypeManager.Encoding, do: defstruct [:name, :code, :category, :label, :width]
defmodule AmqpOne.TypeManager.Descriptor, do: defstruct [:name, :code]
defmodule AmqpOne.TypeManager.Field, do:
  defstruct [:name, :type, :requires, :default, :label, mandatory: false,
    multiple: false]
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

  @type class_t :: :primitive | :composite | :restricted | :union
  @type category_t :: :fixed | :variable | :compound | :array

  defstruct [:type_store]
  @ets_name __MODULE__


  @doc """
  The type specification for the standard types as specified in the xml spec
  of the AMQP 1.0 standard.
  """
  @spec type_spec(String.t) :: Type.t | nil
  # Generate the primitives types
  XML.typespec AmqpOne.TypeManager.XML.xml_spec()
  # this must always be the last resort: We do not find a type and return nil
  def type_spec(name) do
    case :ets.lookup(__MODULE__, name) do
      [] -> nil
      [{^name, type}] -> type
    end
  end

  def start_link() do
    Agent.start_link(fn() ->
      # use ETS default options: set, key on position 1, protected
      %__MODULE__{type_store: :ets.new(__MODULE__, [:named_table])} end, name: __MODULE__)
  end

  def stop() do
    Agent.stop(__MODULE__, :normal)
  end

  @doc "Adds a type with an explicit name"
  def add_type(name, %Type{} = t) do
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
    end)
  end

  defp get_names(%Type{} = t) do
    case t.descriptor do
      nil -> [t.name]
      [%Descriptor{name: n, code: c}] -> [n, c]
    end
  end


end
