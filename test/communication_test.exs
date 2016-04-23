defmodule AmqpOne.Test.Communication do
  use ExUnit.Case

  @host 'localhost'
  @port 5672

  test "open and close the connection" do
    conn = AmqpOne.Transport.open(@host, @port, [])

    assert is_pid(conn)

    :ok = AmqpOne.Transport.close(conn)
    assert not Process.alive?(conn)
  end
end
