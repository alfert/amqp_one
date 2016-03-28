defmodule AmqpOne.Test.Encoding do
  use ExUnit.Case
  require AmqpOne.TypeManager

  test "null encoding" do
    null = AmqpOne.Encoding.encode(nil)
    assert nil == AmqpOne.Encoding.decode(null)
  end

  test "boolean encoding" do
    bin_true = AmqpOne.Encoding.encode(true)
    assert true == AmqpOne.Encoding.decode(bin_true)

    bin_false = AmqpOne.Encoding.encode(false)
    assert false == AmqpOne.Encoding.decode(bin_false)
  end

  test "xml generation" do
    x = AmqpOne.TypeManager.xmlElement(name: :type)
    AmqpOne.TypeManager.convert_xml(x)

    tree = book_spec |> String.to_char_list |> :xmerl_scan.string
    IO.inspect tree
    book = IO.inspect AmqpOne.TypeManager.convert_xml(tree)
    Enum.zip(book.field, book_type.field) |> Enum.all?(fn{f,s} -> assert f == s end)
    assert book.descriptor == book_type.descriptor
  end

  def book_value do
    %{title: "AMQP for & by Dummies",
      authors: ["Rob J. Godfrey", "Rafael H. Schloming"],
      isbn: nil}
  end

  def book_binary() do
    constructor = <<0x00, 0xA3, "example:book:list", 0xc0>>
    title = <<0xa1, 0x15, "AMQP for & by Dummies">>
    godfrey = <<0x0e, "Rob J. Godfrey">>
    schloming = <<0x13, "Rafael H. Schloming">>
    authors = <<0xe0, 0x25, 0x02, 0xa1, godfrey, schloming>>
    isbn = <<0x40>> # null
    book = <<0x40, 0x03, title, authors, isbn>>
  end

  def book_type() do
    alias AmqpOne.TypeManager.Type
    alias AmqpOne.TypeManager.Field
    alias AmqpOne.TypeManager.Descriptor
    spec = %Type{name: "book", class: :composite, label: "example composite type",
      descriptor: [%Descriptor{name: "example:book:list", code: "0x00000003:0x00000002"}],
      field: [
        %Field{name: "title", type: "string", mandatory: true, label: "title of the book"},
        %Field{name: "authors", type: "string", multiple: true},
        %Field{name: "isbn", type: "string", label: "the ISBN code for the book"}
        ]
      }
    spec
  end

  def book_spec() do
    xml_spec =
    """
    <type class="composite" name="book" label="example composite type">
      <doc>
        <p>An example composite type.</p>
      </doc>
      <descriptor name="example:book:list" code="0x00000003:0x00000002"/>
      <field name="title" type="string" mandatory="true" label="title of the book"/>
      <field name="authors" type="string" multiple="true"/>
      <field name="isbn" type="string" label="the ISBN code for the book"/>
    </type>
    """
  end
end
