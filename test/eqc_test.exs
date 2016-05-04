defmodule AmqpOne.Test.Quickcheck do
  use ExUnit.Case
  use EQC.ExUnit

  alias AmqpOne.Encoding
  alias AmqpOne.TypeManager

  property "encode and decode simple values" do
    list_type = TypeManager.type_spec "list"
    forall l <- list(simple_amqp_values) do
      {decoded, <<>>} = Encoding.typed_encoder(l, list_type) |> Encoding.decode_bin
      ensure l == decoded
    end
  end

  def simple_amqp_values do
    oneof [nat, largeint, bool, utf8, real]
  end
end
