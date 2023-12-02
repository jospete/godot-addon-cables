extends Node2D

func _on_count_listener_next(value):
	$Label.text = str(value)
