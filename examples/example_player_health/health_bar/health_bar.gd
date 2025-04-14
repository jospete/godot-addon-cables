@tool
class_name HealthBar extends Control

var _color := Color.GREEN

@onready var _foreground: ColorRect = $ForegroundWrapper/Foreground

@export var foreground_color: Color:
	get: return _color
	set(value): set_foreground_color(value)

@export_range(0.0, 1.0, 0.01) var fill_amount: float:
	get: return get_fill_amount()
	set(value): set_fill_amount(value)

func _ready() -> void:
	set_foreground_color(_color)

func set_foreground_color(value: Color) -> void:
	_color = value
	if _foreground:
		_foreground.color = value

func get_fill_amount() -> float:
	return _foreground.anchor_right if _foreground else 0.0

func set_fill_amount(value: float) -> void:
	if _foreground:
		_foreground.anchor_right = clamp(value, 0.0, 1.0)
