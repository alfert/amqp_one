# AmqpOne

An attempt to implement an AMQP 1.0 compliant client. The OASIS standard document
can be found in the spec folder.

![Build Status][(https://travis-ci.org/alfert/amqp_one.svg?branch=master)](https://travis-ci.org/alfert/amqp_one)

## Concepts from the Standard

### Transport level

Transport happens on behalf of TCP. AMQP defines messaging between nodes.

* An AMPQ network has *nodes* connected via (unidirected) *links* (see below). Nodes live in
  exactly one container (usually a client or broker app), a container holds
  many nodes. There are 3 types of nodes: Producers, Consumers and Queues.
* For transfers, a *connection* has to be opened between nodes. A connection
  transfers an ordered sequence of *frames*. A connection is full-duplex, i.e.
  communicates in both direction at the same time.
* A connection is divided into a unidirected *channels*. Each frame denotes the
  the channel it belongs to.
* A *session* correlates to channels to a bi-directed sequential conversation
  between two containers. Sessions provide a *flow-control schema* [how?].
* A single connection may have many independent sessions active at the same
  time, depending on the negotiated channel limit. Both, connections and
  sessions, are modeled as *endpoints* by the peers, storing local and remote
  state regarding the connection or session, respectively.
* A *link* is required between two nodes in order to transfer messages between the
  nodes. A link is unidirectional and connects at a node at a *terminus*. A terminus
  is either a *source* or a *target* and is responsible for tracking the outgoing
  or incoming stream of messages, respectively. A link provides a credit-based
  flow-control (i.e. back-pressure). Links have names.
* A session provides the context for communication between source and target. A
  *link endpoint* associates a terminus with a *session endpoint*.

These concepts are shown in the diagram: [Transport Concepts](transport.png)

## API Design

This approach is modeled after AMQP.NET Lite (cf. https://dzone.com/refcardz/amqp-essentials)

### Establishing a sender link

    address = “amqp://admin:admin@192.168.1.103:5672”
    {:ok, connection} = AmqpOne.connect(address)
    {:ok, session} = AmqpOne.session(connection)
    {:ok, sender} = AmqpOne.sender_link(session, "sender-link", "queue1")

### Send a message
Now we can send a message via the `sender` with properties, application
specific properties and a timeout:

    props = [message_id: 123]
    app_props = %{"my-prop" => "cool system"}
    AmpqOne.send("Hello AMQP-1", props, app_props, 5_000)


## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed as:

  1. Add amqp_one to your list of dependencies in `mix.exs`:

        def deps do
          [{:amqp_one, "~> 0.0.1"}]
        end

  2. Ensure amqp_one is started before your application:

        def application do
          [applications: [:amqp_one]]
        end
