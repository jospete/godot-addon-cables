# A resource-based signal type.
# Bridges the gap between scene assets, and fixes the issue of
# signal connections getting broken when rearranging scenes.
class_name Cable extends Resource

var _current_value = null
var _did_emit_value: bool = false

# Will notify any CableListener instances when a new value is produced
signal next(value)

# True if this Cable has emitted at least one value
var did_emit_value: bool:
	get:
		return _did_emit_value

# The last emitted value.
# This can be compared against the value received in on_next() where
# this would be the old value, and the value in on_next() would be the new value.
var current_value:
	get:
		return _current_value

# Produce a new value to be passed on to any CableListener instances.
func emit(value) -> void:
	next.emit(value)
	_current_value = value
	_did_emit_value = true

# Connects the given callable to the on_next() signal, and
# calls it immediately with the current value if this Cable has one.
func watch(cb: Callable) -> void:
	next.connect(cb)
	if _did_emit_value:
		cb.call(_current_value)
