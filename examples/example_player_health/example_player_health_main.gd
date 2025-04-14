extends Node2D

@export var main_player_value_cable: Cable
@export var reload_scene_event: Cable

var link_group := CableLinkGroup.new()

func _ready() -> void:
	# Example for linking to cables without the usage of `NodeWithLifetime`
	link_group.collect([
		main_player_value_cable.link(_on_main_player_changed),
		reload_scene_event.link(_on_reload_scene)
		# TODO: add more links here as needed
	])

func _notification(what: int) -> void:
	# Deregister the link group on destroy - this can also be done on
	# `tree_exiting` if that suits your needs.
	if what == NOTIFICATION_PREDELETE:
		link_group.unlink_all()

func _on_main_player_changed(value: Player) -> void:
	print("player updated! -> " + str(value))

func _on_reload_scene(_ev) -> void:
	get_tree().reload_current_scene.call_deferred()
