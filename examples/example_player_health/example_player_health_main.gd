extends Node2D

@export var main_player_value_cable: Cable
@export var reload_scene_event: Cable

func _ready() -> void:
	# Example for linking to cables with a custom `NodeWithLifetime` reference
	var lifetime := NodeWithLifetime.from(self)
	main_player_value_cable.link_until_destroyed(lifetime, _on_main_player_changed)
	reload_scene_event.link_until_destroyed(lifetime, _on_reload_scene)

func _on_main_player_changed(value: Player) -> void:
	print("player updated! -> " + str(value))

func _on_reload_scene(_ev) -> void:
	get_tree().reload_current_scene.call_deferred()
