## Special type of producer that sends a node reference.
##
## This class will track the lifetime of the referenced node,
## and emit a "cleared" event automatically to avoid reference-after-frees.
@tool
@icon("res://addons/cables/icons/producer-icon.svg")
class_name CableNodeValueProducer extends CableValueProducer

## Optional - the node to be broadcast on the assigned [member output] Cable.
## Can also be updated at runtime via [method send_node_value_update].
@export var node_value: Node = null

## Indicates that the [member node_value] should be broadcast on the given
## [member output] as soon as it becomes ready. This should be [code]true[/code]
## in most cases, especially when [member node_value] is set in the editor and not at runtime.
@export var notify_on_node_value_ready := true

## Indicates that the value on the given [member output] should be cleared when
## [i]this[/i] node is destroyed (NOT the [member node_value] node).
## [br][br]
## This node should generally be a child or sibling of the [member node_value] in
## most cases, so the destruction of this node will infer the destruction
## of the target.
## [br][br]
## If this inferred behavior is [i]not[/i] the case, set this value to [code]false[/code]
## and call [method send_node_value_clear] manually instead when you want
## the cable link to be removed.
@export var clear_on_destroy := true

func _ready() -> void:
	if node_value and notify_on_node_value_ready:
		if node_value.is_node_ready():
			send_node_value()
		else:
			node_value.ready.connect(send_node_value)
	
	if clear_on_destroy:
		node_destroyed.connect(send_node_value_clear)

## Broadcasts [param node] on the currently assigned [member output].
func send_node_value_update(node: Node) -> void:
	node_value = node
	send_value_update(node)

## Broadcasts the current [member node_value] value on the given [member output].
## Triggered automatically when [member notify_on_node_value_ready] is [code]true[/code].
func send_node_value() -> void:
	send_node_value_update(node_value)

## Broadcasts [code]null[/code] on the currently assigned [member output].
## Triggered automatically when [member clear_on_destroy] is [code]true[/code].
func send_node_value_clear() -> void:
	send_node_value_update(null)
