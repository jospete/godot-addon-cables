## Plug-and-play transformer for Cables that forwards
## local notify calls onto the target `outlet` Cable.
class_name CableValueProducer extends NodeWithLifetime

## The `Cable` to forward local `notify` calls to.
@export var outlet: Cable

## Emits on the assigned `outlet` Cable with the given value.
func notify(value: Variant) -> void:
	outlet.notify(value)

## Emits a void event on the assigned `outlet` Cable.
func void_notify() -> void:
	outlet.void_notify()
