extends Control

@export var action_name: StringName

@onready var _instructions_label: Label = $Label

func _ready() -> void:
	var action_events := InputMap.action_get_events(action_name)
	var action_key_bind := action_events[0].as_text().replace(" (Physical)", "")
	_instructions_label.text = _instructions_label.text.replace("{action}", action_key_bind)
