## Base class for Cable nodes that are interested in the [signal node_destroyed] event,
## i.e. when this node receives a [b]NOTIFICATION_PREDELETE[/b] message.
class_name NodeWithLifetime extends Node

## Emits when a [b]NOTIFICATION_PREDELETE[/b] notification is intercepted.
signal node_destroyed()

func _notification(what: int) -> void:
	if what == NOTIFICATION_PREDELETE:
		node_destroyed.emit()

## Translates the given [param node] into a [NodeWithLifetime] reference.
## [br][br]
## This returned instance will reflect the lifecycle events of the given [param node],
## i.e. when the returned instance is about to be deleted, it is inferred
## that the origin [param node] will also be deleted.
## [br][br]
## If the given [param node] is already a [NodeWithLifetime] instance
## it will be returned as-is.
## [br][br]
## If the given [param node] has a child node which is a [NodeWithLifetime] instance,
## that child node will be returned.
## [br][br]
## If neither of the above cases are met, this will create a new [NodeWithLifetime]
## instance and append it as a child of the given [param node].
static func from(node: Node) -> NodeWithLifetime:
	if node is NodeWithLifetime:
		return node as NodeWithLifetime
	
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
