## Base class for Cable nodes that are interested in the `node_destroyed` event,
## i.e. when this node receives a `NOTIFICATION_PREDELETE` message.
class_name NodeWithLifetime extends Node

## Emits when a `NOTIFICATION_PREDELETE` notification is intercepted.
signal node_destroyed()

func _notification(what: int) -> void:
	if what == NOTIFICATION_PREDELETE:
		node_destroyed.emit()
