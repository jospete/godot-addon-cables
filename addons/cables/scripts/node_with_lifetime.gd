## Base class for Cable nodes that are interested in the `node_destroyed` event,
## i.e. when this node receives a `NOTIFICATION_PREDELETE` message.
class_name NodeWithLifetime extends Node

## Emits when a `NOTIFICATION_PREDELETE` notification is intercepted.
signal node_destroyed()

func _notification(what: int) -> void:
	if what == NOTIFICATION_PREDELETE:
		node_destroyed.emit()

## Adds a `NodeWithLifetime` child node to the given node.
## This infers the lifecycle events of the given node to the child,
## i.e. when the child node is about to be deleted, it is inferred
## that the parent will also be deleted.
##
## If a the given node already has a child node that is
## a `NodeWithLifetime` instance, this will re-use that node.
static func from(node: Node) -> NodeWithLifetime:
	var result: NodeWithLifetime = null
	
	for c in node.get_children():
		if c is NodeWithLifetime:
			result = c as NodeWithLifetime
			break
	
	if result == null:
		result = NodeWithLifetime.new()
		node.add_child(result)
		result.name = "%s_LifetimeContext" % node.name
	
	return result
