## Special type of producer that sends a void event in response to an input action,
## based on this node's configuration.
## This node type should always be added as a direct child of a Button node type.
@tool
@icon("res://addons/cables/icons/producer-icon.svg")
class_name CableInputEventProducer extends CableValueProducer

enum TriggerType {
	JUST_PRESSED,
	JUST_RELEASED,
	HELD_DOWN
}

@export var action: StringName = ""
@export var trigger_type: TriggerType = TriggerType.JUST_PRESSED

var is_target_event_type: Callable = func(): return false

func _ready() -> void:
	match trigger_type:
		TriggerType.JUST_PRESSED: is_target_event_type = _is_just_pressed
		TriggerType.JUST_RELEASED: is_target_event_type = _is_just_released
		TriggerType.HELD_DOWN: is_target_event_type = _is_held_down
		_: push_warning("Unknown trigger type: %s" % str(trigger_type))

func _is_just_pressed() -> bool:
	return Input.is_action_just_pressed(action)

func _is_just_released() -> bool:
	return Input.is_action_just_released(action)

func _is_held_down() -> bool:
	return Input.is_action_pressed(action)

func _unhandled_input(_event: InputEvent) -> void:
	var is_required_action: bool = is_target_event_type.call()
	if is_required_action: send_void_update()
