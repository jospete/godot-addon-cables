## Special type of producer that sends a void event in response to button interaction,
## based on this node's configuration.
## This node type should always be added as a direct child of a Button node type.
@tool
@icon("res://addons/cables/icons/producer-icon.svg")
class_name CableButtonEventProducer extends CableValueProducer

enum TriggerType {
	PRESSED,
	BUTTON_DOWN,
	BUTTON_UP
}

@export var trigger_type: TriggerType = TriggerType.PRESSED

var _button: Button = null

func _ready() -> void:
	var p := get_parent()
	
	if p is Button:
		_button = p as Button
	
	if _button == null or Engine.is_editor_hint():
		return
	
	match trigger_type:
		TriggerType.PRESSED: _button.pressed.connect(send_void_update)
		TriggerType.BUTTON_DOWN: _button.button_down.connect(send_void_update)
		TriggerType.BUTTON_UP: _button.button_up.connect(send_void_update)
		_: push_warning("Unknown trigger type detected: %s" % str(trigger_type))

func _get_configuration_warnings() -> PackedStringArray:
	var warnings := super._get_configuration_warnings()
	var p := get_parent()
	if not (p is Button):
		warnings.append("Parent node must be a Button")
	return warnings
