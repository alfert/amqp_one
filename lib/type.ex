defmodule AmqpOne.TypeManager do

  import Record
  Record.defrecord :xmlElement, Record.extract(:xmlElement, from_lib: "xmerl/include/xmerl.hrl")
  Record.defrecord :xmlAttribute, Record.extract(:xmlAttribute, from_lib: "xmerl/include/xmerl.hrl")
  Record.defrecord :xmlText, Record.extract(:xmlText, from_lib: "xmerl/include/xmerl.hrl")
  Record.defrecord :xmlNamespace, Record.extract(:xmlNamespace, from_lib: "xmerl/include/xmerl.hrl")


  @type class_t :: :primitive | :composite | :restricted | :union
  @type category_t :: :fixed | :variable | :compound | :array

  defmodule Type, do: defstruct [:name, :class, :provides, :label, :encoding,
      :doc, :field, :choice, :descriptor]
  defmodule Encoding, do: defstruct [:name, :code, :category, :label, :width]
  defmodule Descriptor, do: defstruct [:name, :code]
  defmodule Field, do:
    defstruct [:name, :type, :requires, :default, :label, :mandatory, :multiple]
  defmodule Choice, do: defstruct [:name, :value, :doc]

  def type_spec("null") do
    %Type{name: "null", class: :primitve, encoding:
      %Encoding{code: <<"0x40">>, category: :fixed, width: 0, label: "the null value"}}
  end

  @doc "Takes the xmerl_scan results and produces a type spec"
  def convert_xml({type, _}), do:  convert_xml(type)
  def convert_xml(type) when is_record(type, :xmlElement) and xmlElement(type, :name) == :type do
    IO.puts "Found XML: type (atom)"
    attrs = xmlElement(type, :attributes) |> Enum.map(&convert_xml/1)
    children = xmlElement(type, :content) |> Enum.map(&convert_xml/1) |> collect_children
    t = %Type{name: attrs[:name], label: attrs[:label], class: attrs[:class],
      encoding: children[:enc], field: children[:field], choice: children[:choice],
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
    %Encoding{name: attrs[:name], label: attrs[:label], category: attrs[:category],
      code: attrs[:code], width: attrs[:width]}
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
end
