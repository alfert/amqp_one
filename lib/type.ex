defmodule AmqpOne.TypeManager.Type, do: defstruct [:name, :class, :provides, :label, :encodings,
    :doc, :fields, :choices, :descriptor, :source]
defmodule AmqpOne.TypeManager.Encoding, do: defstruct [:name, :code, :category, :label, :width]
defmodule AmqpOne.TypeManager.Descriptor, do: defstruct [:name, :code]
defmodule AmqpOne.TypeManager.Field, do:
  defstruct [:name, :type, :requires, :default, :label, mandatory: false,
    multiple: false]
defmodule AmqpOne.TypeManager.Choice, do: defstruct [:name, :value, :doc]

defmodule AmqpOne.TypeManager do

  alias AmqpOne.TypeManager.XML
  require AmqpOne.TypeManager.XML
  alias AmqpOne.TypeManager.{Type, Field, Descriptor, Encoding, Choice}

  @type class_t :: :primitive | :composite | :restricted | :union
  @type category_t :: :fixed | :variable | :compound | :array


  @doc """
  The type specification for the standard types as specified in the xml spec
  of the AMQP 1.0 standard.
  """
  # def type_spec("null") do
  #   %Type{name: "null", class: :primitve, encodings:
  #     [%Encoding{code: <<"0x40">>, category: :fixed, width: 0, label: "the null value"}]}
  # end
  # Generate the primitives types
  XML.typespec AmqpOne.TypeManager.XML.xml_spec()

end
