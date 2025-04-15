## Plug-and-play transformer for Cables that localizes
## cable signals into local ones that can be bound to in the editor.
@icon("res://addons/cables/icons/consumer-icon.svg")
class_name CableValueConsumer extends NodeWithLifetime

## Emits when the `input` cable emits a value that is not `Cable.VOID_EVENT`
signal value_updated(value: Variant)

## Emits when the `input` cable emits a `VOID_EVENT`
signal void_update()

## Emits when either a value update or void update occurs
signal any_update()

## The Cable to forward events from
@export var input: Cable

func _ready() -> void:
	input.debug_log("Consumer<%s> link_until_destroyed()" % str(self))
	input.link_until_destroyed(self, _on_cable_value_update)

func _on_cable_value_update(value: Variant) -> void:
	any_update.emit()
	if Cable.is_void_event(value):
		input.debug_log("Consumer<%s> void_update()" % str(self))
		void_update.emit()
	else:
		input.debug_log("Consumer<%s> value_updated(%s)" % [str(self), str(value)])
		value_updated.emit(value)
