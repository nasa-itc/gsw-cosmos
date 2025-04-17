# SIM_CMDBUS_BRIDGE - NOS3 Remote Command Bus Bridge Support

This target contains command and telemetry definitions to support communicating
with  NOS3 simulators via the non-flight command bus interface.  The command
bus interface allows for commanding and configuring NOS3 simulator behavior and
values to support fault injection and behavior emulation.  

COSMOS connects to the _sim_cmdbus_bridge_ NOS3 component via the SIM_CMDBUS_BRIDGE_INT
INTERFACE.  The _sim_cmdbus_bridge_ component receives JSON strings over a network 
connection and dispatches them to NOS3 command bus.  The _sim_cmdbus_bridge_ uses
the _node_ field in the message to determine which simulator to send the message
to.

## Base JSON Format
Each target message JSON must contain the minimum fields:
```
{
    "node":"target_node",
    "cmd_id":1
}
```
Where:
- **node:** Name of NOS3 simulator node the message will be sent to
- **cmd_id:** Unique integer value for a specific command.  Each simulator
is free to define its own definition for each command id.

> **NOTE:** The _sim_cmdbus_bridge_ server expects a single line JSON string with a
single carriage return at the end.  Do not transmit a JSON string with multiple
carriage returns as the server will treat each carriage return as a separate message.
The appending of the carriage return is handled by the SIM_CMDBUS_BRIDGE_INT interface
definition.

## Extending JSON Protocol

Beyond the base JSON format, command definitions can contain additional fields as
needed.  For example, below is an example of a message with a floating ponit value:
```
{
    "node":"target_node",
    "cmd_id":1,
    "value": 1.5
}
```

## COSMOS Template Protocol

COSMOS provides a template based protocol that allows for configuring a command
string based on specified parameters in the message definition.  The message
parameters don't describe the format of the packet, but provide a means to
specify values that will replace tokens in the CMD_TEMPLATE parameter.  The
CMD_TEMPATE parameter describes the actual message that is sent to the target
device.

![alt text](doc/cosmos_cmdtarget_def.png "COSMOS Command Template")

See [here](https://cosmosrb.com/news/2017/06/19/template_protocol/) for more
information.