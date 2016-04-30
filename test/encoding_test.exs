defmodule AmqpOne.Test.Encoding do
  use ExUnit.Case
  require AmqpOne.TypeManager.XML
  require Logger
  alias AmqpOne.TypeManager, as: TM
  alias AmqpOne.TypeManager.{Type, Field, Descriptor}
  alias AmqpOne.Encoding
  alias AmqpOne.Transport
  alias AmqpOne.TypeManager.XML
  alias AmqpOne.Test.TypeSpec


  test "null encoding" do
    null = AmqpOne.Encoding.typed_encoder(nil, TM.type_spec("null"))
    assert nil == AmqpOne.Encoding.decode(null)
  end

  test "boolean encoding" do
    bin_true = AmqpOne.Encoding.typed_encoder(true, TM.type_spec("boolean"))
    assert true == AmqpOne.Encoding.decode(bin_true)

    bin_false = AmqpOne.Encoding.typed_encoder(false, TM.type_spec("boolean"))
    assert false == AmqpOne.Encoding.decode(bin_false)
  end

  test "small utf8 encoding" do
    s = "Hallo"
    expected = <<0xa1, 0x05>> <> s # , s :: utf8>>
    bin = Encoding.typed_encoder(<<"Hallo">>, TM.type_spec("string"))

    assert expected == bin
  end

  test "xml generation" do
    x = AmqpOne.TypeManager.XML.xmlElement(name: :type)
    AmqpOne.TypeManager.XML.convert_xml(x)

    tree = book_spec |> String.to_char_list |> :xmerl_scan.string
    # IO.puts "The book spec as XMerl tree:"
    # IO.inspect tree
    # IO.puts "The converted tree for a book: "
    book = AmqpOne.TypeManager.XML.convert_xml(tree) # |> IO.inspect
    Enum.zip(book.fields, book_type().fields) |> Enum.all?(fn{f,s} -> assert f == s end)
    assert book.descriptor == book_type.descriptor
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

    assert byte_size(my_book) == byte_size(book_binary)

    # extract the last bytes
    my_end = binary_part(my_book, byte_size(my_book), -60)
    book_end = binary_part(book_binary, byte_size(book_binary), -60)
    assert my_end == book_end

    # extract the first bytes
    my_start = binary_part(my_book, 40, 40)
    book_start = binary_part(book_binary, 40, 40)
    assert my_start == book_start

    # byte_differ(my_book, book_binary)

    assert my_book == book_binary()
  end

  test "decode the book" do
    # 0x00 is normally eliminated by decode_bin for a composite value
    # before running the typed_decoder. Thus we have to do it here
    # by hand.
    TM.start_link()
    TM.add_type(book_type())
    <<0x00, book_bin :: binary>> = book_binary()
    {my_book, <<>>} = Encoding.decode_bin(book_binary)# Encoding.typed_decoder(book_bin, book_type())

    assert my_book == book_value()
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

  test "decoder for lists" do
    types = %{<<0x45>> => [],
      <<0xc0, 4, 2, 0x53, 1, 0x53, 2>> => [1, 2]}
    type = TM.type_spec "list"
    types
    |> Enum.each(fn {l, e} ->
      assert type.class == :primitive
      {encoded, <<>>} = Encoding.typed_decoder(l, type)
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

  test "decoder for maps" do
    types = %{<<0xc1, 0, 0>> => %{},
      <<0xc1, 8, 4, 0x53, 1, 0x53, 2, 0x53, 3, 0x53, 4>>
       => %{1 => 2, 3=>4}
    }
    types
    |> Map.to_list
    |> Enum.each(fn {l, e} ->
      type = TM.type_spec "map"
      assert type.class == :primitive
      {encoded, <<>>} = Encoding.typed_decoder(l, type)
      assert encoded == e
    end)
  end

  test "encoder for arrays" do
    test_values = %{[1, 2] => <<0xe0, 2*8, 2, 0x80, 1 :: size(64), 2 :: size(64)>>,
      [] => <<0xe0, 0, 0, 0x40>>}
    type = TM.type_spec("array")
    test_values
    |> Enum.each(fn {l, e} ->
      assert type.class == :primitive
      encoded = Encoding.typed_encoder(l, type)
      assert encoded == e
    end)
  end

  test "decoder for arrays" do
    test_values = %{<<0xe0, 2*8, 2, 0x80, 1 :: size(64), 2 :: size(64)>> => [1, 2],
      <<0xe0, 0, 0, 0x40>> => []}
    type = TM.type_spec("array")
    test_values
    |> Enum.each(fn {l, e} ->
      assert type.class == :primitive
      {encoded, rest} = Encoding.typed_decoder(l, type)
      assert encoded == e
      assert rest == ""
    end)
  end


  test "adding types to type manager" do
    TM.add_type("book", book_type())
    assert book_type() == TM.type_spec("book")

    TM.add_type(book_type())
    assert book_type() == TM.type_spec("example:book:list")
  end

  test "Transfer Frame encoding" do
    alias AmqpOne.Transport.Frame
    channel = :random.uniform(65636) -1
    # length = :random.uniform(50) - 1
    # data = 1..length |> Enum.map(fn _ -> :random.uniform() end)
    data = "Hello AMQP! This is Elixir!"
    trans = %Frame.Transfer{handle: 1}
    enc = Transport.encode_frame(channel, trans, data) |> IO.iodata_to_binary
    Logger.info "encoded frame is : #{inspect enc}"
    assert {^channel, value} = Transport.decode_frame(enc)
    assert {^trans, ^data} = value
  end

  test "Frame type specification" do
    spec = XML.frame_spec("amqp-core-transport-v1.0-os.xml")
    assert %{} = spec
    # Logger.debug "Spec is: #{inspect spec}"
    assert %Type{} = spec["begin"]
  end

  test "extract fields of a type" do
    b_type =  book_type()
    assert Map.has_key?(b_type, :fields)
    fs = b_type.fields |> Enum.map(&XML.extract_field/1)
    fs |> Enum.each(fn f -> assert f.name in [:isbn, :title, :authors] end )
  end

  test "use a frame struct" do
    open = %AmqpOne.Test.TypeSpec.Open{}
    assert open.container_id == nil
  end

  test "finding the struct of a type " do
    type = TM.type_spec("open")
    struct = TM.struct_for_type(type)

    assert %AmqpOne.Transport.Frame.Open{} = struct
  end

  test "find provided types" do
    types = TM.type_spec("delivery-state")
    assert is_list(types)
    assert Enum.member?(types, TM.type_spec("received"))
    assert Enum.member?(types, TM.type_spec("accepted"))
  end

  test "Encode the open frame" do
    hostname = 'localhost'
    open_frame = %AmqpOne.Transport.Frame.Open{container_id: "Testing",
      hostname: "#{hostname}",
      max_frame_size: 1024*1024, channel_max: 10,
      idle_time_out: 5_000, properties: %{}
    }
    [bin, <<>>] = Transport.encode_frame(0, open_frame)

    {0, {frame, ""}} = Transport.decode_frame(bin)

    assert open_frame == frame
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
    constructor = <<0x00, 0xA3, 0x11, "example:book:list", 0xc0, 0x45, 0x03>>
    title = <<0xa1, 0x15, "AMQP for & by Dummies">>
    # authors is an array of 2 utf-8 elements
    # we use 32 bit length as our encoding of arrays (code 0xb1), to prevent
    # scanning of all array entries before encoding. 32 bit is always
    # big enough (per definition). This is different from the example
    # in the standard (0xa1).
    godfrey = <<0x0e :: size(32), "Rob J. Godfrey">>
    schloming = <<0x13 :: size(32), "Rafael H. Schloming">>
    authors = <<0xe0, 0x29, 0x02, 0xb1, godfrey :: binary, schloming :: binary>>
    isbn = <<0x40>> # null
    book = constructor <> title <> authors <> isbn
  end

  def book_type() do
    spec = %Type{name: "book", class: :composite, label: "example composite type",
      descriptor: [%Descriptor{name: "example:book:list", code: 0x0000000300000002}],
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

  def byte_differ(first, second) do
    max = byte_size(first) -1
    0..max
    |> Enum.each(fn i ->
      f = :binary.at(first, i)
      s = :binary.at(second, i)
      if f != s do
        IO.ANSI.red
        IO.puts("")
        IO.puts "position #{i}: fst= #{Integer.to_string(f,16)}, snd=#{Integer.to_string(s,16)}"
        IO.ANSI.normal
      else
        IO.write "#{Integer.to_string(f,16)}"
        if i < max, do: IO.write ", "
      end
    end)
  end

end
