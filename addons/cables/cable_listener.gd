# Unwraps a Cable's on_next() signal into a normal
# signal that can be bound to via the inspector.
# These signals should not connected to above this node's scope.
class_name CableListener extends Node

# Emits when any value comes in
signal next(value)

# Emits only when the value has changed from the previous value
signal changed(new_val, old_val)

# The Cable to connect to and listen for events
@export var cable: Cable

var _did_emit_change: bool = false

# Bind to the event's signal, rather than to another scene/node signal directly.
# This allows the ResourceEvent instance to act as a safe barrier between
# scene instances when building levels / UI hooks.
func _ready() -> void:
	cable.watch(_forward_proxy_event)

func _forward_proxy_event(value) -> void:
	next.emit(value)
	
	if not _did_emit_change or cable.current_value != value:
		changed.emit(value, cable.current_value)
		_did_emit_change = true
