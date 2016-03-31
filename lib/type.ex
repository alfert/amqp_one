defmodule AmqpOne.TypeManager do


  @type class_t :: :primitive | :composite | :restricted | :union
  @type category_t :: :fixed | :variable | :compound | :array

  defmodule Type, do: defstruct [:name, :class, :provides, :label, :encodings,
      :doc, :fields, :choices, :descriptor]
  defmodule Encoding, do: defstruct [:name, :code, :category, :label, :width]
  defmodule Descriptor, do: defstruct [:name, :code]
  defmodule Field, do:
    defstruct [:name, :type, :requires, :default, :label, :mandatory, :multiple]
  defmodule Choice, do: defstruct [:name, :value, :doc]

  @doc """
  The type specification for the standard types as specified in the xml spec
  of the AMQP 1.0 standard.
  """
  def type_spec("null") do
    %Type{name: "null", class: :primitve, encodings:
      [%Encoding{code: <<"0x40">>, category: :fixed, width: 0, label: "the null value"}]}
  end

  defmodule XML do
    import Record
    Record.defrecord :xmlElement, Record.extract(:xmlElement, from_lib: "xmerl/include/xmerl.hrl")
    Record.defrecord :xmlAttribute, Record.extract(:xmlAttribute, from_lib: "xmerl/include/xmerl.hrl")
    Record.defrecord :xmlText, Record.extract(:xmlText, from_lib: "xmerl/include/xmerl.hrl")
    Record.defrecord :xmlNamespace, Record.extract(:xmlNamespace, from_lib: "xmerl/include/xmerl.hrl")

    @doc """
    Generate the typespecs from the XML specification.
    Returns the `type_spec` function which takes a type name as
    argument and returns the Elixir equivalent of the XML spec.
    """
    defmacro typespec(xml_string) do
      # Generate the primitives types
      "<t>" <> xml_string <> "</t>"
      |> String.to_char_list
      |> :xmerl_scan.string
      |> convert_xml
      |> Enum.map(fn({name, spec}) ->
        quote do
          def type_spec(unquote(name)), do: unquote(Macro.escape(spec))
        end
      end)
    end

    @doc "Takes the xmerl_scan results and produces a type spec"
    def convert_xml({type, _}), do:  convert_xml(type)
    def convert_xml(type) when is_record(type, :xmlElement) and xmlElement(type, :name) == :t do
      xmlElement(type, :content)
      |> Enum.map(&convert_xml/1)
      |> collect_children
      |> Map.fetch!(:type)
      |> Stream.map(fn t = %Type{name: name} -> {name, t} end)
      |> Enum.into(%{})
    end
    def convert_xml(type) when is_record(type, :xmlElement) and xmlElement(type, :name) == :type do
      IO.puts "Found XML: type (atom)"
      attrs = xmlElement(type, :attributes) |> Enum.map(&convert_xml/1)
      children = xmlElement(type, :content) |> Enum.map(&convert_xml/1) |> collect_children
      t = %Type{name: attrs[:name], label: attrs[:label], class: attrs[:class],
        encodings: children[:enc], fields: children[:field], choices: children[:choice],
        descriptor: children[:desc]}
    end
    def convert_xml(field) when is_record(field, :xmlElement) and xmlElement(field, :name) == :field do
      attrs = xmlElement(field, :attributes) |> Enum.map(&convert_xml/1)
      %Field{name: attrs[:name], label: attrs[:label], type: attrs[:type],
        requires: attrs[:requires], default: attrs[:default],
        mandatory: attrs[:mandatory], multiple: attrs[:multiple]}
    end
    def convert_xml(desc) when is_record(desc, :xmlElement) and xmlElement(desc, :name) == :descriptor do
      attrs = xmlElement(desc, :attributes) |> Enum.map(&convert_xml/1)
      %Descriptor{name: attrs[:name], code: attrs[:code]}
    end
    def convert_xml(choice) when is_record(choice, :xmlElement) and xmlElement(choice, :name) == :choice do
      attrs = xmlElement(choice, :attributes) |> Enum.map(&convert_xml/1)
      %Choice{name: attrs[:name], value: attrs[:value]}
    end

    def convert_xml(enc) when is_record(enc, :xmlElement) and xmlElement(enc, :name) == :encoding do
      attrs = xmlElement(enc, :attributes) |> Enum.map(&convert_xml/1)
      {width, _rest} = Integer.parse(attrs[:width])
      %Encoding{name: attrs[:name], label: attrs[:label], category: attrs[:category],
        code: attrs[:code], width: width}
    end
    # catch all unknown elements
    def convert_xml(enc) when is_record(enc, :xmlElement), do: nil
    def convert_xml(attr) when is_record(attr, :xmlAttribute) and
          xmlAttribute(attr, :name) == :class do
      {:class, xmlAttribute(attr, :value) |> List.to_atom}
    end
    def convert_xml(attr) when is_record(attr, :xmlAttribute) and
          xmlAttribute(attr, :name) == :category do
      {:category, xmlAttribute(attr, :value) |> List.to_atom}
    end
    def convert_xml(attr) when is_record(attr, :xmlAttribute) and
      xmlAttribute(attr, :value) == 'true' do
        {xmlAttribute(attr, :name), true}
    end
    def convert_xml(attr) when is_record(attr, :xmlAttribute) and
      xmlAttribute(attr, :value) == 'false' do
        {xmlAttribute(attr, :name), false}
    end
    def convert_xml(attr) when is_record(attr, :xmlAttribute) and
      is_list(xmlAttribute(attr, :value)) do
        {xmlAttribute(attr, :name), "#{xmlAttribute(attr, :value)}"}
    end
    def convert_xml(attr) when is_record(attr, :xmlAttribute) do
      {xmlAttribute(attr, :name), xmlAttribute(attr, :value)}
    end
    def convert_xml(txt) when is_record(txt, :xmlText), do: nil

    @spec collect_children([tuple]) :: Map.t(:type|:enc|:field|:choice|:desc, [tuple])
    def collect_children(children) do
      # effectively an ordered Enum.group_by
      children
      |> Stream.reject(&(&1 == nil))
      |> Stream.map(fn(value) ->
        case value do
          %Type{} -> {:type, value}
          %Encoding{} -> {:enc, value}
          %Field{} -> {:field, value}
          %Choice{} -> {:choice, value}
          %Descriptor{} -> {:desc, value}
        end
      end)
      |> Enum.reduce(%{}, fn({key, value}, acc) ->
        # this is slow, but there aren't that many keys
        acc |> Map.update(key, [value], fn(old) -> old ++ [value] end)
      end)
    end


    # This is the specification of types copied from the AMQP 1.0 standard
    # (section 1.6 "Primitive Type Definitions", lines 883-1080)
    @xml_spec """
    <type class="primitive" name="null" label="indicates an empty value">
      <encoding code="0x40" category="fixed" width="0" label="the null value"/>
    </type>

    <type class="primitive" name="boolean" label="represents a true or false value">
      <encoding code="0x56" category="fixed" width="1" label="boolean with the octet 0x00 being false and octet 0x01 being true"/>
      <encoding name="true" code="0x41" category="fixed" width="0" label="the boolean value true"/>
      <encoding name="false" code="0x42" category="fixed" width="0" label="the boolean value false"/>
    </type>

    <type class="primitive" name="ubyte" label="integer in the range 0 to 2^8 - 1 inclusive">
      <encoding code="0x50" category="fixed" width="1" label="8-bit unsigned integer"/>
    </type>

    <type class="primitive" name="ushort" label="integer in the range 0 to 2^16 - 1 inclusive">
      <encoding code="0x60" category="fixed" width="2" label="16-bit unsigned integer in network byte order"/>
    </type>

    <type class="primitive" name="uint" label="integer in the range 0 to 2^32 - 1 inclusive">
      <encoding code="0x70" category="fixed" width="4" label="32-bit unsigned integer in network byte order"/>
      <encoding name="smalluint" code="0x52" category="fixed" width="1" label="unsigned integer value in the range 0 to 255 inclusive"/>
      <encoding name="uint0" code="0x43" category="fixed" width="0" label="the uint value 0"/>
    </type>

    <type class="primitive" name="ulong" label="integer in the range 0 to 2^64 - 1 inclusive">
      <encoding code="0x80" category="fixed" width="8" label="64-bit unsigned integer in network byte order"/>
      <encoding name="smallulong" code="0x53" category="fixed" width="1" label="unsigned long value in the range 0 to 255 inclusive"/>
      <encoding name="ulong0" code="0x44" category="fixed" width="0" label="the ulong value 0"/>
    </type>

    <type class="primitive" name="byte" label="integer in the range -(2^7) to 2^7 - 1 inclusive">
      <encoding code="0x51" category="fixed" width="1" label="8-bit two's-complement integer"/>
    </type>

    <type class="primitive" name="short" label="integer in the range -(2^15) to 2^15 - 1 inclusive">
      <encoding code="0x61" category="fixed" width="2" label="16-bit two's-complement integer in network byte order"/>
    </type>

    <type class="primitive" name="int" label="integer in the range -(2^31) to 2^31 - 1 inclusive">
      <encoding code="0x71" category="fixed" width="4" label="32-bit two's-complement integer in network byte order"/>
      <encoding name="smallint" code="0x54" category="fixed" width="1" label="8-bit two's-complement integer"/>
    </type>

    <type class="primitive" name="long" label="integer in the range -(2^63) to 2^63 - 1 inclusive">
      <encoding code="0x81" category="fixed" width="8" label="64-bit two's-complement integer in network byte order"/>
      <encoding name="smalllong" code="0x55" category="fixed" width="1" label="8-bit two's-complement integer"/>
    </type>

    <type class="primitive" name="float" label="32-bit floating point number (IEEE 754-2008 binary32)">
      <encoding name="ieee-754" code="0x72" category="fixed" width="4" label="IEEE 754-2008 binary32"/>
      <doc>
        <p>
          A 32-bit floating point number (IEEE 754-2008 binary32
          [<xref name="IEEE754">IEEE754</xref>]).
        </p>
      </doc>
    </type>

    <type class="primitive" name="double" label="64-bit floating point number (IEEE 754-2008 binary64)">
      <encoding name="ieee-754" code="0x82" category="fixed" width="8" label="IEEE 754-2008 binary64"/>
      <doc>
        <p>
          A 64-bit floating point number (IEEE 754-2008 binary64
          [<xref name="IEEE754">IEEE754</xref>]).
        </p>
      </doc>
    </type>

    <type class="primitive" name="decimal32" label="32-bit decimal number (IEEE 754-2008 decimal32)">
      <encoding name="ieee-754" code="0x74" category="fixed" width="4" label="IEEE 754-2008 decimal32 using the Binary Integer Decimal encoding"/>
      <doc>
        <p>
          A 32-bit decimal number (IEEE 754-2008 decimal32
          [<xref name="IEEE754">IEEE754</xref>]).
        </p>
      </doc>
    </type>

    <type class="primitive" name="decimal64" label="64-bit decimal number (IEEE 754-2008 decimal64)">
      <encoding name="ieee-754" code="0x84" category="fixed" width="8" label="IEEE 754-2008 decimal64 using the Binary Integer Decimal encoding"/>
      <doc>
        <p>
          A 64-bit decimal number (IEEE 754-2008 decimal64
          [<xref name="IEEE754">IEEE754</xref>]).
        </p>
      </doc>
    </type>

    <type class="primitive" name="decimal128" label="128-bit decimal number (IEEE 754-2008 decimal128)">
      <encoding name="ieee-754" code="0x94" category="fixed" width="16" label="IEEE 754-2008 decimal128 using the Binary Integer Decimal encoding"/>
      <doc>
        <p>
          A 128-bit decimal number (IEEE 754-2008 decimal128
          [<xref name="IEEE754">IEEE754</xref>]).
        </p>
      </doc>
    </type>

    <type class="primitive" name="char" label="a single Unicode character">
      <encoding name="utf32" code="0x73" category="fixed" width="4" label="a UTF-32BE encoded Unicode character"/>
      <doc>
        <p>
          A UTF-32BE encoded Unicode character
          [<xref name="UNICODE6">UNICODE6</xref>].
        </p>
      </doc>

    </type>

    <type class="primitive" name="timestamp" label="an absolute point in time">
      <encoding name="ms64" code="0x83" category="fixed" width="8" label="64-bit two's-complement integer representing milliseconds since the unix epoch">
        <doc>
          <p>
            Represents an approximate point in time using the Unix time_t [<xref name="IEEE1003">IEEE1003</xref>] encoding of UTC, but with a precision of milliseconds.
            For example, 1311704463521 represents the moment 2011-07-26T18:21:03.521Z.
          </p>
        </doc>
      </encoding>
    </type>

    <type class="primitive" name="uuid" label="a universally unique identifier as defined by RFC-4122 section 4.1.2 ">
      <encoding code="0x98" category="fixed" width="16" label="UUID as defined in section 4.1.2 of RFC-4122"/>
      <doc>
        <p>
          UUID is defined in section 4.1.2 of RFC-4122 [<xref name="RFC4122">RFC4122</xref>].
        </p>
      </doc>
    </type>

    <type class="primitive" name="binary" label="a sequence of octets">
      <encoding name="vbin8" code="0xa0" category="variable" width="1" label="up to 2^8 - 1 octets of binary data"/>

      <encoding name="vbin32" code="0xb0" category="variable" width="4" label="up to 2^32 - 1 octets of binary data"/>
    </type>

    <type class="primitive" name="string" label="a sequence of Unicode characters">
      <doc>
        <p>
           A string represents a sequence of Unicode characters as defined by the Unicode V6.0.0
           standard [<xref name="UNICODE6">UNICODE6</xref>].
        </p>
      </doc>
      <encoding name="str8-utf8" code="0xa1" category="variable" width="1" label="up to 2^8 - 1 octets worth of UTF-8 Unicode (with no byte order mark)"/>

      <encoding name="str32-utf8" code="0xb1" category="variable" width="4" label="up to 2^32 - 1 octets worth of UTF-8 Unicode (with no byte order mark)"/>
    </type>

    <type class="primitive" name="symbol" label="symbolic values from a constrained domain">
      <doc>
        <p>
          Symbols are values from a constrained domain. Although the set of possible domains is
          open-ended, typically the both number and size of symbols in use for any given application
          will be small, e.g. small enough that it is reasonable to cache all the distinct values.
          Symbols are encoded as ASCII characters [<xref name="ASCII">ASCII</xref>].
        </p>
      </doc>

      <encoding name="sym8" code="0xa3" category="variable" width="1" label="up to 2^8 - 1 seven bit ASCII characters representing a symbolic value"/>

      <encoding name="sym32" code="0xb3" category="variable" width="4" label="up to 2^32 - 1 seven bit ASCII characters representing a symbolic value"/>
    </type>

    <type class="primitive" name="list" label="a sequence of polymorphic values">
      <encoding name="list0" code="0x45" category="fixed" width="0" label="the empty list (i.e. the list with no elements)"/>
      <encoding name="list8" code="0xc0" category="compound" width="1" label="up to 2^8 - 1 list elements with total size less than 2^8 octets"/>
      <encoding name="list32" code="0xd0" category="compound" width="4" label="up to 2^32 - 1 list elements with total size less than 2^32 octets"/>
    </type>

    <type class="primitive" name="map" label="a polymorphic mapping from distinct keys to values">
      <doc>
          <p>
            A map is encoded as a compound value where the constituent elements form alternating key
            value pairs.
          </p>

          <picture title="Layout of Map Encoding">
          item 0   item 1      item n-1    item n
          +-------+-------+----+---------+---------+
          | key 1 | val 1 | .. | key n/2 | val n/2 |
          +-------+-------+----+---------+---------+

          </picture>
        <p>
          Map encodings MUST contain an even number of items (i.e. an equal number of keys and
          values). A map in which there exist two identical key values is invalid. Unless known to
          be otherwise, maps MUST be considered to be ordered, that is, the order of the key-value
          pairs is semantically important and two maps which are different only in the order in
          which their key-value pairs are encoded are not equal.
        </p>
      </doc>
      <encoding name="map8" code="0xc1" category="compound" width="1" label="up to 2^8 - 1 octets of encoded map data"/>
      <encoding name="map32" code="0xd1" category="compound" width="4" label="up to 2^32 - 1 octets of encoded map data"/>
    </type>

    <type class="primitive" name="array" label="a sequence of values of a single type">
      <encoding name="array8" code="0xe0" category="array" width="1" label="up to 2^8 - 1 array elements with total size less than 2^8 octets"/>
      <encoding name="array32" code="0xf0" category="array" width="4" label="up to 2^32 - 1 array elements with total size less than 2^32 octets"/>
    </type>
  """
  end

end
