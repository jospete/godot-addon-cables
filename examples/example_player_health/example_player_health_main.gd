extends Node2D

@export var main_player_value_cable: Cable
@export var reload_scene_event: Cable

var _cable_links: CableLinkGroup

func _ready() -> void:
	_cable_links = CableLinkGroup.with_lifetime_of(self).append([
		main_player_value_cable.link(_on_main_player_changed),
		reload_scene_event.link(_on_reload_scene),
	])

func _on_main_player_changed(value: Player) -> void:
	print("player updated! -> " + str(value))

func _on_reload_scene(_ev) -> void:
	get_tree().reload_current_scene.call_deferred()
