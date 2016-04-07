defmodule AmqpOne.Test.Encoding do
  use ExUnit.Case
  require AmqpOne.TypeManager.XML
  alias AmqpOne.TypeManager, as: TM
  alias AmqpOne.TypeManager.{Type, Field, Descriptor}
  alias AmqpOne.Encoding


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

  test "small utf8 encoding" do
    s = "Hallo"
    expected = <<0xa1, 0x05>> <> s # , s :: utf8>>
    bin = Encoding.encode_utf8(<<"Hallo">>)

    assert expected == bin
  end

  test "xml generation" do
    x = AmqpOne.TypeManager.XML.xmlElement(name: :type)
    AmqpOne.TypeManager.XML.convert_xml(x)

    tree = book_spec |> String.to_char_list |> :xmerl_scan.string
    # IO.puts "The book spec as XMerl tree:"
    # IO.inspect tree
    # IO.puts "The converted tree for a book: "
    book = IO.inspect AmqpOne.TypeManager.XML.convert_xml(tree)
    Enum.zip(book.fields, book_type().fields) |> Enum.all?(fn{f,s} -> assert f == s end)
    assert book.descriptor == book_type.descriptor
  end

  defmodule TypeSpec do
    require AmqpOne.TypeManager.XML, as: X

    X.typespec("""
    <type class="primitive" name="null" label="indicates an empty value">
      <encoding code="0x40" category="fixed" width="0" label="the null value"/>
    </type>
    """)
    # The type_spec function for book
    X.typespec("""
      <type class="composite" name="book" label="example composite type">
        <doc>
          <p>An example composite type.</p>
        </doc>
        <descriptor name="example:book:list" code="0x00000003:0x00000002"/>
        <field name="title" type="string" mandatory="true" label="title of the book"/>
        <field name="authors" type="string" multiple="true"/>
        <field name="isbn" type="string" label="the ISBN code for the book"/>
      </type>
    """)
  end

  test "type spec generation for null" do
    null_spec = TypeSpec.type_spec("null")
    assert %TM.Type{} = null_spec
    [enc] = null_spec.encodings
    assert enc.category == :fixed
    assert enc.width == 0
    assert enc.code == <<0x40>>
  end

  test "type spec for book" do
    my_book_spec = TypeSpec.type_spec("book")
    assert my_book_spec == book_type()
  end

  test "encode the book" do
    my_book = Encoding.typed_encoder(book_value(), book_type())
    |> IO.iodata_to_binary()

    # extract the last 20 bytes
    my_end = binary_part(my_book, byte_size(my_book), -50)
    book_end = binary_part(book_binary, byte_size(book_binary), -50)
    assert my_end == book_end

    assert my_book == book_binary()
  end

  test "primitive encoder for numbers" do
    value = 5
    types = %{"double" => <<0x82, 64, 20, 0, 0, 0, 0, 0, 0>>, "byte" => <<0x51, 5>>,
    "short" => <<0x61, 0, 5>>, "int" => <<0x54, 5>>, "ubyte" => <<0x50, 5>>,
    "char" => <<0x73, 0, 0, 0, 5>>}
    types
    |> Enum.each(fn {t, e} ->
      type = TM.type_spec t
      assert type.class == :primitive
      encoded = Encoding.primitive_encoder(value, type)
      assert encoded == e
    end)
  end

  test "encoder for lists" do
    types = %{[] => <<0x45>>, [1, 2] => <<0xc0, 4, 2, 0x53, 1, 0x53, 2>>}
    types
    |> Enum.each(fn {l, e} ->
      type = Encoding.type_of l
      assert type.class == :primitive
      encoded = Encoding.typed_encoder(l, type)
      assert encoded == e
    end)
  end

  test "encoder for maps" do
    types = %{%{} => <<0xc1, 0, 0>>, %{1 => 2, 3=>4} =>
      <<0xc1, 8, 4, 0x53, 1, 0x53, 2, 0x53, 3, 0x53, 4>>}
    types
    |> Enum.each(fn {l, e} ->
      type = Encoding.type_of l
      assert type.class == :primitive
      encoded = Encoding.typed_encoder(l, type)
      assert encoded == e
    end)
  end


  def url_value, do: "http://example.org/hello-world"

  def url_type do
    # source denotes the base type, which is (somehow) restricted,
    # i.e. URL subset of String
    %Type{class: :restricted, name: "URL", source: "string"}
  end

  def url_binary() do
    # UTF8-String of length 0x03 with value "URL"
    descriptor = <<0xa1, 0x03, "URL">>
    # descriptor value, "URL", value is UTF8 (0xa1)
    constructor = <<0x00, descriptor, 0xa1>>
    # length of URL string
    url = url_value
    len = String.length(url)
    <<constructor, len, url >>
  end

  def book_value do
    %{title: "AMQP for & by Dummies",
      authors: ["Rob J. Godfrey", "Rafael H. Schloming"],
      isbn: nil}
  end

  def book_binary() do
    # con = constructed (00) as symbol8(a3) with x11 characters
    # a compund is a list of field (0xc0 = list8)
    constructor = <<0x00, 0xA3, 0x11, "example:book:list", 0xc0, 0x03>>
    title = <<0xa1, 0x15, "AMQP for & by Dummies">>
    # authors is an array of 2 utf-8 elements
    # we use 32 bit length as our encoding of arrays (code 0xb1), to prevent
    # scanning of all array entries before encoding. 32 bit is always
    # big enough (per definition). This is different from the example
    # in the standard (0xa1), but the example as also an other obvious
    # error: the list constructor must be 0xc0 and not 0x40, which would
    # be null.
    godfrey = <<0x0e :: size(32), "Rob J. Godfrey">>
    schloming = <<0x13 :: size(32), "Rafael H. Schloming">>
    authors = <<0xe0, 0x29, 0x02, 0xb1, godfrey :: binary, schloming :: binary>>
    isbn = <<0x40>> # null
    book = constructor <> title <> authors <> isbn
  end

  def book_type() do
    spec = %Type{name: "book", class: :composite, label: "example composite type",
      descriptor: [%Descriptor{name: "example:book:list", code: "0x00000003:0x00000002"}],
      fields: [
        %Field{name: :title, type: "string", mandatory: true, label: "title of the book"},
        %Field{name: :authors, type: "string", multiple: true},
        %Field{name: :isbn, type: "string", label: "the ISBN code for the book"}
        ]
      }
    spec
  end

  def book_spec() do
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
