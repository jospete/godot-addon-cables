## Special type of producer that sends a node reference.
## This class will track the lifetime of the referenced node,
## and emit a "cleared" event automatically to avoid reference-after-frees.
@icon("res://addons/cables/icons/producer-icon.svg")
class_name CableNodeValueProducer extends CableValueProducer

## Optional - the node to be broadcast on the assigned `outlet` Cable.
## Can also be updated at runtime via `notify_target_updated()`.
@export var node_value: Node = null

## Indicates that the `target` should be broadcast on the given `outlet`
## as soon as it becomes ready. This should be `true` in most cases,
## especially when `target` is set in the editor and not at runtime.
@export var notify_on_node_value_ready := true

## Indicates that the value on the given `outlet` should be cleared when
## _this_ node is destroyed (NOT the `target` node).
##
## This node should generally be a child or sibling of the `target` in
## most cases, so the destruction of this node will infer the destruction
## of the target.
##
## If this implied behavior is _not_ the case, set this value to `false`
## and call `notify_target_cleared()` manually instead.
@export var clear_on_destroy := true

func _ready() -> void:
	if node_value and notify_on_node_value_ready:
		if node_value.is_node_ready():
			send_node_value()
		else:
			node_value.ready.connect(send_node_value)
	
	if clear_on_destroy:
		node_destroyed.connect(send_node_value_clear)

## Broadcasts `node` on the currently assigned `outlet`.
func send_node_value_update(node: Node) -> void:
	send_value_update(node)

## Broadcasts the current `target` value on the given `outlet`.
## Triggered automatically when `notify_on_target_ready` is true.
func send_node_value() -> void:
	send_node_value_update(node_value)

## Broadcasts `null` on the currently assigned `outlet`.
## Triggered automatically when `clear_on_destroy` is true.
func send_node_value_clear() -> void:
	send_node_value_update(null)
