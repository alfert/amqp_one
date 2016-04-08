defmodule AmqpOne.Encoding do
  @moduledoc """
  This module contains the logic for encoding and decoding typed
  AMQP streams.
  """
  require Logger
  alias AmqpOne.TypeManager
  alias AmqpOne.TypeManager.{Type, Encoding, Field, Descriptor, Choice}

  @spec encode(any) :: binary
  def encode(nil), do: <<0x40>>
  def encode(true), do: <<0x41>>
  def encode(false), do: <<0x42>>

  def encode_utf8(bin) when is_binary(bin) and byte_size(bin) <=255,
    do: <<0xa1, byte_size(bin) :: size(8)>> <>  bin
  def encode_utf8(bin) when is_binary(bin),
    do: <<0xb1, byte_size(bin) :: size(32)>> <> bin


  def parse(<<0x4 :: size(4), type :: size(4), rest :: binary>>) do
    [decode(<<0x4::size(4), type>>)]
  end

  @doc """
  Encodes an Elixir value according to the AMQP type specification.

  Generally, this approach tries to minimize the amount of data, but
  for array types this is not possible. Here, all encodings use the
  same constructor and thus an array of `ulong` values consists of
  64-bit only. The data compression format of using one or two bytes
  for small values (`0` or `< 256`) cannot be used.

  This is the reason to use the extra parameter `in_array`, which,
  if true, requires an uncompressed data fornat without a constructor.
  The constructor is computed explicitely in the array construction
  branch of the encoder.
  """
  @spec typed_encoder(any, Type.t | Descriptor.t | Encoding.t | Field.t, boolean) :: iodata
  def typed_encoder(value, type, in_array \\ false)
  def typed_encoder(value, %Type{class: :primitive} = t, in_array) do
    primitive_encoder(value, t, in_array)
  end
  def typed_encoder(%{} = value, %Type{class: :composite} = t, in_array) do
    # a composite has a descriptor and a list of fields
    con = if in_array, do: [], # no con required due to array
        else: typed_encoder(value, t.descriptor)
    field_count = Enum.count(t.fields)
    list_con = if field_count > 255 do
      <<0xd0, field_count :: size(32)>>
    else
      <<0xc0, field_count :: size(8)>>
    end
    list_elements = t.fields |> Enum.map(fn(field) ->
      val = value[field.name]
      # Logger.debug "Encode field #{inspect field.name} with value #{inspect val}"
      typed_encoder(val, field)
    end)
    [con, list_con, list_elements]
  end
  def typed_encoder(value, %Type{class: :restricted, choices: nil} = t, _in_array) do
    # no choices means no enumaration, but a subtype of an existing type
    source_type = TypeManager.type_spec(t.source)
    [typed_encoder(value, t.descriptor), typed_encoder(value, source_type)]
  end
  def typed_encoder(_value, [%Descriptor{name: name} = d], _in_array) do
    # constructor = 0, descriptor name as string
    # Logger.info "encode descriptor with name #{inspect name}"
    [<<0x0>>, typed_encoder(name, TypeManager.type_spec("symbol"))]
  end
  # fields cannot be in an array
  # mandatory null must be encoded explicitely
  def typed_encoder(nil, %Field{mandatory: true}, false), do: encode(nil)
  def typed_encoder(nil, %Field{mandatory: false}, false), do: [encode(nil)]
  def typed_encoder(value, %Field{multiple: true, type: type}, false) when is_list(value) do
    # encode an array of values
    t = TypeManager.type_spec(type)
    elems = value
    |> Enum.map(&(typed_encoder(&1, t, true)))
    |> IO.iodata_to_binary
    array_size = byte_size(elems)
    array_count = length(value)
    constructor = uncompressed_encoding(t).code
    # put the fields together
    array_head = if array_count > 255 do
      <<0xf0, array_size :: size(32), array_count :: size(32)>>
    else
      <<0xe0, array_size :: size(8), array_count :: size(8)>>
    end
    [array_head, constructor, elems]
  end
  def typed_encoder(value, %Field{multiple: false, type: type}, false) do
    t = TypeManager.type_spec(type)
    typed_encoder(value, t)
  end
  def typed_encoder(value, type_name, in_array) when is_binary(type_name) do
    typed_encoder(value, TypeManager.type_spec(type_name), in_array)
  end

  @doc """
  The constructor makes only sense for not constructor encoded values,
  i.e. not for booleans, but for strings
  """
  @spec uncompressed_encoding(Type.t) :: Encoding.t
  def uncompressed_encoding(%Type{class: :primitive} = t) do
    t.encodings
    |> Enum.max_by(fn e -> e.width end)
  end

  def enc(encodings, width) do
    Enum.find(encodings, fn e -> e.width==width end)
  end

  def primitive_encoder(value, type, in_array \\ false)
  def primitive_encoder(value, %Type{class: :primitive, name: name} = t, in_array)
        when name in ["ubyte", "ushort", "uint", "ulong"] do
    case value do
      0 when not in_array -> <<enc(t.encodings, 0).code>>
      x when x < 256 and not in_array ->
        e = enc(t.encodings, 1)
        s = e.width * 8
        e.code <> <<value :: size(s)>>
      x when not in_array ->
          e = uncompressed_encoding(t)
          s = e.width * 8
          e.code <> <<value :: size(s)>>
      x ->
          e = uncompressed_encoding(t)
          s = e.width * 8
          <<value :: size(s)>>
    end
  end
  def primitive_encoder(value, %Type{class: :primitive, name: name} = t, in_array)
        when name in [ "int", "long"] do
    case value do
      x when x >-127 and x < 128 and not in_array ->
        e = enc(t.encodings, 1)
        s = e.width * 8
        e.code <> <<value :: size(s)-signed>>
      x when not in_array ->
          e = uncompressed_encoding(t)
          s = e.width * 8
          e.code <> <<value :: size(s)-signed>>
      x  ->
          e = uncompressed_encoding(t)
          s = e.width * 8
          <<value :: size(s)-signed>>
    end
  end
  def primitive_encoder(value, %Type{class: :primitive, name: name} = t, false)
        when name in [ "byte", "short"] do
    e = uncompressed_encoding(t)
    s = e.width * 8
    # Logger.debug "byte/short: e.code = #{e.code}, binary? #{is_binary(e.code)}"
    e.code <> <<value :: size(s)-signed-integer>>
  end
  def primitive_encoder(value, %Type{class: :primitive, name: name} = t, true)
        when name in [ "byte", "short"] do
    e = uncompressed_encoding(t)
    s = e.width * 8
    <<e.code, value :: size(s)-signed>>
  end
  def primitive_encoder(value, %Type{class: :primitive, name: "double"} = t, in_array) do
    # float in Erlang/Elixir = double in IEEE 754
    if in_array, do: <<value :: float>>, else: <<0x82, value :: float>>
  end
  def primitive_encoder(value, %Type{class: :primitive, name: "boolean"}, false) do
    encode(value)
  end
  def primitive_encoder(value, %Type{class: :primitive, name: "boolean"}, true) do
    if value == true, do: <<1 :: size(8)>>, else: <<0 :: size(8)>>
  end
  def primitive_encoder(value, %Type{class: :primitive, name: "char"} = t, in_array) do
    if in_array, do: <<value :: utf32>>, else: <<0x73, value :: utf32>>
  end
  def primitive_encoder(value, %Type{class: :primitive, name: "timestamp"} = t, in_array) do
    # timestamp = 64 bit unsigned integer
    if in_array, do: <<value :: size(64)>>, else: <<0x83, value :: size(64)>>
  end
  def primitive_encoder(value, %Type{class: :primitive, name: name} = t, in_array)
      when name in ["string", "binary", "symbol"] do
    case byte_size(value) do
      s when s < 255 and not in_array ->
        e = enc(t.encodings, 1)
        e.code <> <<s>> <> value
      s when not in_array ->
        e = enc(t.encodings, 4)
        e.code <> <<s :: size(32)>> <> value
      s ->
        # Logger.debug "string: bytesize: #{s}, value= #{inspect value}"
        <<s :: integer-size(32)>> <> value
    end
  end
  def primitive_encoder(value, %Type{class: :primitive, name: "list"} = t, in_array) do
    elems = value
    |> Enum.map(&(typed_encoder(&1, type_of(&1), false)))
    |> IO.iodata_to_binary
    size = byte_size(elems)
    count = length(value)
    # put the list together
    case size do
      0 -> <<0x45>>
      x when x > 255 or in_array ->
        if in_array, do: <<size :: size(32), count :: size(32)>> <> elems,
          else: <<0xd0, size :: size(32), count :: size(32)>> <> elems
      _x -> <<0xc0, size :: size(8), count :: size(8)>>  <> elems
    end
  end
  def primitive_encoder(value, %Type{class: :primitive, name: "map"} = t, in_array) do
    elems = value
    |> Enum.map(fn {k, v} ->
      [typed_encoder(k, type_of(k), false), typed_encoder(v, type_of(v), false)] end)
    |> IO.iodata_to_binary
    size = byte_size(elems)
    count = 2 * Enum.count value
    # put the list together
    case size do
      x when x > 255 ->
        if in_array,
          do: <<size :: size(32), count :: size(32)>> <> elems,
          else: <<0xd1, size :: size(32), count :: size(32)>> <> elems
      _x -> <<0xc1, size :: size(8), count :: size(8)>>  <> elems
    end
  end
  def primitive_encoder(value, %Type{class: :primitive, name: "array"} = t, in_array) do
    type = List.first(value) |> type_of
    elems = value
    |> Enum.map(&(typed_encoder(&1, type, true)))
    |> IO.iodata_to_binary
    size = byte_size(elems)
    count = length(value)
    constructor = uncompressed_encoding(type)
    # put the array together
    head = case size do
      x when x > 255 or in_array ->
        if in_array do
           <<size :: size(32), count :: size(32)>>
         else
           <<0xf0, size :: size(32), count :: size(32)>>#
         end
      _x -> <<0xe0, size :: size(8), count :: size(8)>>
    end
    head <> constructor.code <> elems
  end

  @doc "Tries to identify the type of an Elixir value according to AMQP"
  def type_of(nil), do: TypeManager.type_spec("null")
  def type_of(b) when b in [true, false], do: TypeManager.type_spec("boolean")
  def type_of(a) when is_atom(a), do: TypeManager.type_spec("symbol")
  def type_of(l) when is_list(l), do: TypeManager.type_spec("list")
  def type_of(m) when is_map(m) do
    # and is a short-cut: returns false or the result of the 2nd argument
    case Map.has_key?(m, :__struct__) and TypeManager.type_spec(m.__struct__) do
      false -> TypeManager.type_spec("map")
      nil   -> TypeManager.type_spec("map")
      type  -> type
    end
  end
  def type_of(i) when is_integer(i) do
    if i >= 0,
      do: TypeManager.type_spec("ulong"),
      else: TypeManager.type_spec("long")
  end
  def type_of(f) when is_float(f), do: TypeManager.type_spec("double")


  def decode(<<0x40>>), do: nil
  def decode(<<0x41>>), do: true
  def decode(<<0x42>>), do: false

end
