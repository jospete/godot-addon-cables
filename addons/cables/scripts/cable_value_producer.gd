## Plug-and-play transformer for Cables that forwards
## local send calls onto the target `output` Cable.
@icon("res://addons/cables/icons/producer-icon.svg")
class_name CableValueProducer extends NodeWithLifetime

## The `Cable` to forward local `send` calls to.
@export var output: Cable

## Emits on the assigned `output` Cable with the given value.
func send_value_update(value: Variant) -> void:
	output.debug_log("Producer<%s> send_value_update(%s)" % [str(self), str(value)])
	output.notify(value)

## Emits a void event on the assigned `output` Cable.
func send_void_update() -> void:
	output.debug_log("Producer<%s> send_void_update()" % str(self))
	output.void_notify()
