defmodule AmqpOne.Test.TypeSpec do
  require AmqpOne.TypeManager.XML, as: X

  # We cannot give a function or a module constant to these macros.
  # Therefore, the literals are used everywhere.

  X.typespec("""
  <t>
    <type class="primitive" name="null" label="indicates an empty value">
      <encoding code="0x40" category="fixed" width="0" label="the null value"/>
    </type>
  </t>)
  """)

  # The type_spec function for book

  X.typespec("""
  <t>
    <type class="composite" name="book" label="example composite type">
      <doc>
        <p>An example composite type.</p>
      </doc>
      <descriptor name="example:book:list" code="0x00000003:0x00000002"/>
      <field name="title" type="string" mandatory="true" label="title of the book"/>
      <field name="authors" type="string" multiple="true"/>
      <field name="isbn" type="string" label="the ISBN code for the book"/>
    </type>
  </t>
  """)

  X.frame_structs("amqp-core-transport-v1.0-os.xml")
end
