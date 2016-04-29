defmodule AmqpOne.Transport.Frame do
  @moduledoc """
  This module holds all AMQP frame structs
  """
  require AmqpOne.TypeManager.XML, as: XML

  XML.frame_structs("amqp-core-transport-v1.0-os.xml")
  XML.frame_structs("amqp-core-messaging-v1.0-os.xml")

  def init() do
    XML.add_frames_to_typemanager("amqp-core-transport-v1.0-os.xml")
    XML.add_frames_to_typemanager("amqp-core-messaging-v1.0-os.xml")
    :ok
  end

end
