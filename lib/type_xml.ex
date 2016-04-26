defmodule AmqpOne.TypeManager.XML do

  @moduledoc """
  This module provides access to the XML specification of AMQP and provides
  the type definitions.

  It used during compilation to generate various functions, modules,
  type and struct definitions. Many functions cannot be used properly after
  the compilation, unless the specification is provided by the user.
  """

  import Record
  Record.defrecord :xmlElement, Record.extract(:xmlElement, from_lib: "xmerl/include/xmerl.hrl")
  Record.defrecord :xmlAttribute, Record.extract(:xmlAttribute, from_lib: "xmerl/include/xmerl.hrl")
  Record.defrecord :xmlText, Record.extract(:xmlText, from_lib: "xmerl/include/xmerl.hrl")
  Record.defrecord :xmlNamespace, Record.extract(:xmlNamespace, from_lib: "xmerl/include/xmerl.hrl")

  alias AmqpOne.TypeManager.{Type, Field, Descriptor, Encoding, Choice}

  @doc "Takes the xmerl_scan results and produces a type spec"
  def convert_xml({type, _}), do: convert_xml(type)
  def convert_xml(doc) when is_record(doc, :xmlElement) and xmlElement(doc, :name) in [:amqp] do
    xmlElement(doc, :content)
    |> Enum.map(&convert_xml/1)
    |> Enum.filter(fn
      nil -> false
      _ -> true
    end)
    # |> IO.inspect()
    |> Enum.reduce(%{}, fn
      nil, map ->  map
      types, map when is_map(types) -> Map.merge(map, types)
    end)
    # |> IO.inspect()
  end
  def convert_xml(type) when is_record(type, :xmlElement) and xmlElement(type, :name) in [:t, :section] do
    # IO.puts ("convert_xml: #{inspect xmlElement(type, :name)}")
    xmlElement(type, :content)
    |> Enum.map(&convert_xml/1)
    |> collect_children
    |> Map.get(:type, [])
    |> Stream.map(fn t = %Type{name: name} -> {name, t} end)
    |> Enum.into(%{})
  end
  def convert_xml(type) when is_record(type, :xmlElement) and xmlElement(type, :name) == :type do
    attrs = xmlElement(type, :attributes) |> Enum.map(&convert_xml/1)
    children = xmlElement(type, :content) |> Enum.map(&convert_xml/1) |> collect_children
    name = attrs[:name]
    # IO.puts "convert_xml: type #{inspect name}"
    %Type{name: name, label: attrs[:label], class: attrs[:class],
      encodings: children[:enc], fields: children[:field], choices: children[:choice],
      source: attrs[:source],
      descriptor: children[:desc]}
  end
  def convert_xml(field) when is_record(field, :xmlElement) and xmlElement(field, :name) == :field do
    attrs = xmlElement(field, :attributes) |> Enum.map(&convert_xml/1)
    name = normalize_fieldname(attrs[:name])
    type = attrs[:type]
    %Field{name: name, label: attrs[:label], type: type,
      requires: attrs[:requires], default: attrs[:default],
      mandatory: boolean(attrs[:mandatory]), multiple: boolean(attrs[:multiple])}
  end
  def convert_xml(desc) when is_record(desc, :xmlElement) and xmlElement(desc, :name) == :descriptor do
    attrs = xmlElement(desc, :attributes) |> Enum.map(&convert_xml/1)
    # code is an element of two 32 bit numbers, separated by a colon.
    {code, <<>>} = attrs[:code]
    |> String.replace("0x", "")
    |> String.replace(":", "")
    |> Integer.parse(16)
    %Descriptor{name: attrs[:name], code: code}
  end
  def convert_xml(choice) when is_record(choice, :xmlElement) and xmlElement(choice, :name) == :choice do
    attrs = xmlElement(choice, :attributes) |> Enum.map(&convert_xml/1)
    %Choice{name: attrs[:name], value: attrs[:value]}
  end

  def convert_xml(enc) when is_record(enc, :xmlElement) and xmlElement(enc, :name) == :encoding do
    attrs = xmlElement(enc, :attributes) |> Enum.map(&convert_xml/1)
    {width, _rest} = Integer.parse(attrs[:width])
    "0x" <> hex = attrs[:code]
    {code_val, _rest} = Integer.parse(hex, 16)
    # IO.puts "Code_val #{inspect code_val} of code: #{attrs[:code]}"
    code = <<code_val::integer-size(8)>>
    %Encoding{name: attrs[:name], label: attrs[:label], category: attrs[:category],
      code: code, width: width}
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
        xmlAttribute(attr, :name) == :source do
    {:source,"#{xmlAttribute(attr, :value)}"}
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
        %{} -> {:nothing, nil}
      end
    end)
    |> Enum.reduce(%{}, fn({key, value}, acc) ->
      # this is slow, but there aren't that many keys
      acc |> Map.update(key, [value], fn(old) -> old ++ [value] end)
    end)
  end

  defp boolean(nil), do: false
  defp boolean(true), do: true
  defp boolean(false), do: false

  @doc """
  The XML specification of the primitive types of AMQP 1.0.
  """
  def xml_spec(), do: File.read!("spec/amqp-core-v1/amqp-core-types-v1.0-os.xml")

  @doc """
  Converts the Frame specification (`amqp-core-transport-v1.0-os.xml`) into
  the type definition
  """
  @spec frame_spec() :: %{String.t => Type.t}
  def frame_spec() do
    File.read!("spec/amqp-core-v1/amqp-core-transport-v1.0-os.xml")
    |> String.to_char_list
    |> :xmerl_scan.string
    |> convert_xml
  end

  def generate_struct(%Type{class: :composite} = t, parent_mod) do
    IO.puts "Found comp type #{t.name}"
    fs = t.fields |> Enum.map(&extract_field/1)
    field_list = fs |> Enum.map(fn f -> {f.name, f.value} end)
    type_list = fs
    |> Enum.map(fn f -> {f.name, f.type} end)
    |> Enum.map(fn {n, t} -> quote do unquote(n) :: unquote(t) end end)
    mod_name = struct_name(t.name, parent_mod)
    quote do
      defmodule unquote(mod_name) do
        defstruct unquote(field_list)
        @type t :: %unquote(mod_name){} # {unquote(type_list)}
      end
    end
  end
  def generate_struct(%Type{} = t, _parent_mod) do
    IO.puts "Ignore simple type #{t.name}"
    []
  end

  def struct_name(name, parent_mod) do
    Atom.to_string(parent_mod) <>
      "." <> (name |> String.capitalize)
    |> normalize_fieldname
  end

  def extract_field(%Field{name: n, type: t} = f) do
    name = n |> normalize_fieldname
    type = t |> underscore |> amqp_type
    value = case f do
      %Field{multiple: true} -> []
      %Field{default: nil} -> nil
      %Field{default: "true"} when type == :boolean -> true
      %Field{default: "false"} when type == :boolean -> false
      %Field{default: d} ->
        if type in [:integer, :non_neg_integer, :pos_integer] do
          {num, <<>>} = Integer.parse(d, 10)
          num
        else
          d
        end
    end
    %{name: name, value: value, type: type}
  end

  def normalize_fieldname(name) do
    name |> underscore |> String.to_atom
  end

  def underscore(a) when is_atom(a) do
    Atom.to_string(a) |> underscore
  end
  def underscore(string) do
    String.replace(string, "-", "_")
  end

  @doc "map amqp type to their Elixir counterparts (if they have other names)"
  def amqp_type("*"), do: :any
  def amqp_type("array"), do: :list
  def amqp_type("string"), do: :"Elixir.String.t"
  def amqp_type("symbol"), do: :atom
  def amqp_type("uuid"), do: :binary
  def amqp_type(f) when f in ["double", "float"], do: :float
  def amqp_type(n) when n in ["ubyte", "ushort", "uint", "ulong"], do: :non_neg_integer
  def amqp_type(i) when i in ["byte", "short", "int", "long", "timestamp"], do: :integer
  def amqp_type(any_other_type), do: String.to_atom(any_other_type)

  defmacro frame_structs do
    frame_spec()
    |> Enum.reject(fn entry -> entry == [] end)
    |> Enum.map(fn {name, type} -> generate_struct type, __CALLER__.module end)
  end

  defmacro add_frames_to_typemanager do
    add_statements = frame_spec()
    |> Enum.reject(fn entry -> entry == [] end)
    |> Enum.map(fn {name, type} ->
      t = Macro.escape(type)
      s = struct_name(type.name, __CALLER__.module)
      struct = Macro.escape(s)
      if type.class == :composite do
        # IO.puts "add frame #{inspect type}"
        IO.puts "the struct name is: #{inspect s}"
        quote do
          AmqpOne.TypeManager.add_type(unquote(name), unquote(t))
          AmqpOne.TypeManager.add_type(unquote(t))
          AmqpOne.TypeManager.add_type(%unquote(struct){}, unquote(t))
        end
      else
        quote do
          AmqpOne.TypeManager.add_type(unquote(name), unquote(t))
          AmqpOne.TypeManager.add_type(unquote(t))
        end
      end
    end)
  end

  @doc """
  Generate the typespecs from the XML specification.
  Returns the `type_spec` function which takes a type name as
  argument and returns the Elixir equivalent of the XML spec.
  """
  defmacro typespec(xml_string) do
    {s, _} = Code.eval_quoted(xml_string)
    String.to_char_list(s)
    |> :xmerl_scan.string
    |> convert_xml
    |> Enum.map(fn({name, spec}) ->
      quote do
        def type_spec(unquote(name)), do: unquote(Macro.escape(spec))
      end
    end)
  end

end
