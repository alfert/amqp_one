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
      descriptor: children[:desc]}
  end
  def convert_xml(field) when is_record(field, :xmlElement) and xmlElement(field, :name) == :field do
    attrs = xmlElement(field, :attributes) |> Enum.map(&convert_xml/1)
    name = String.to_atom(attrs[:name])
    type = attrs[:type]
    %Field{name: name, label: attrs[:label], type: type,
      requires: attrs[:requires], default: attrs[:default],
      mandatory: boolean(attrs[:mandatory]), multiple: boolean(attrs[:multiple])}
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

  def boolean(nil), do: false
  def boolean(true), do: true
  def boolean(false), do: false

  @doc """
  The XML specification of the primitive types of AMQP 1.0.
  """
  def xml_spec(), do: File.read!("spec/amqp-core-v1/amqp-core-types-v1.0-os.xml")

  def frame_spec() do
    File.read!("spec/amqp-core-v1/amqp-core-transport-v1.0-os.xml")
    |> String.to_char_list
    |> :xmerl_scan.string
    |> convert_xml
  end

  @doc """
  Generate the typespecs from the XML specification.
  Returns the `type_spec` function which takes a type name as
  argument and returns the Elixir equivalent of the XML spec.
  """
  defmacro typespec(xml_string) do
    {s, _} = Code.eval_quoted(xml_string)
    # "<t>" <> s <> "</t>"
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
