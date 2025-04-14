## Plug-and-play transformer for Cables that localizes
## cable signals into local ones that can be bound to in the editor.
class_name CableValueConsumer extends NodeWithLifetime

## Emits when the `ingress` cable emits a value that is not `Cable.VOID_EVENT`
signal value_updated(value: Variant)

## Emits when the `ingress` cable emits a `VOID_EVENT`
signal void_update()

## The signal to forward events from
@export var ingress: Cable

func _ready() -> void:
	ingress.debug_log("Consumer<%s> link_to_node_lifetime" % str(self))
	ingress.link_to_node_lifetime(self, _on_cable_value_update)

func _on_cable_value_update(value: Variant) -> void:
	if Cable.is_void_event(value):
		ingress.debug_log("Consumer<%s> void_update" % str(self))
		void_update.emit()
	else:
		ingress.debug_log("Consumer<%s> value_updated(%s)" % [str(self), str(value)])
		value_updated.emit(value)
