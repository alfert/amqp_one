defmodule AmqpOne.Encoding do
  @moduledoc """
  This module contains the logic for encoding and decoding typed
  AMQP streams.
  """

  @spec encode(any) :: binary
  def encode(nil), do: <<0x40>>
  def encode(true), do: <<0x56, 0x41>>
  def encode(false), do: <<0x56, 0x42>>


  def parse(<<0x4 :: size(4), type :: size(4), rest :: binary>>) do
    [decode(<<0x4::size(4), type>>)]
  end

  def typed_encoder(value, type) do

  end

  def decode(<<0x40>>), do: nil
  def decode(<<0x56, 0x41>>), do: true
  def decode(<<0x56, 0x42>>), do: false

end
