class_name Coin extends Node2D

@export var count_cable: Cable

var _clicked: bool = false

func _ready():
	$Body/Sprite.play("default")

func _on_character_body_2d_input_event(viewport, event, shape_idx):
	if not _clicked and event.is_action_pressed("left_click"):
		notify_click()

func notify_click():
	_clicked = true
	var value = 1 if not count_cable.did_emit_value \
		else count_cable.current_value + 1
	count_cable.emit(value)
	queue_free()
