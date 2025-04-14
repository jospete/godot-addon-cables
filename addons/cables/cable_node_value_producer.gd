## Base class to translate localized values into global cable event values.
class_name CableNodeValueProducer extends CableValueProducer

## Optional - the node to be broadcast on the assigned `outlet` Cable.
## Can also be updated at runtime via `notify_target_updated()`.
@export var target: Node

## Indicates that the `target` should be broadcast on the given `outlet`
## as soon as it becomes ready. This should be `true` in most cases,
## especially when `target` is set in the editor and not at runtime.
@export var notify_on_target_ready := true

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
	if notify_on_target_ready: target.ready.connect(notify_target)
	if clear_on_destroy: node_destroyed.connect(notify_target_cleared)

## Broadcasts the current `target` value on the given `outlet`.
## Triggered automatically when `notify_on_target_ready` is true.
func notify_target() -> void:
	notify(target)

## Broadcasts `null` on the currently assigned `outlet`.
## Triggered automatically when `clear_on_destroy` is true.
func notify_target_cleared() -> void:
	notify(null)

## Broadcasts `node` on the currently assigned `outlet`.
func notify_target_updated(node: Node) -> void:
	target = node
	notify_target()
