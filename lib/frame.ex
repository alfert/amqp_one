defmodule AmqpOne.Transport.Frame do
  @moduledoc """
  This module holds all AMQP frame structs
  """
  require AmqpOne.TypeManager.XML, as: XML

  XML.frame_structs()

  def init() do
    XML.add_frames_to_typemanager()
    :ok
  end

end
