defmodule AmqpOne.Test.Quickcheck do
  use ExUnit.Case
  use EQC.ExUnit

  alias AmqpOne.Encoding
  alias AmqpOne.TypeManager

  property "encode and decode simple values" do
    list_type = TypeManager.type_spec "list"
    forall l <- list(simple_amqp_values) do
      {decoded, <<>>} = Encoding.typed_encoder(l, list_type) |> Encoding.decode_bin
      # collect l: l, in:
        ensure l == decoded
    end
  end

  property "encode and decode arrays" do
    array_type = TypeManager.type_spec "array"
    forall {t, n} <- {simple_amqp_values, nat} do
      forall a <- vector(10, t) do
        {decoded, <<>>} = Encoding.typed_encoder(a, array_type) |> Encoding.decode_bin
        # collect n: n, in:
          ensure a == decoded
      end
    end
  end

  @doc "Generator for simple, i.e. unstructed AMQP values"
  def simple_amqp_values do
    oneof [int, largeint, bool, real, atom, utf8]
  end

  @doc "Generator for a set of atoms"
  def atom do
    let s <- list(char) do
      :erlang.list_to_atom(s)
    end
  end
end
