extends Node2D

@onready var _label: Label = $Label

func _on_count_listener_next(value):
	_label.text = str(value)
