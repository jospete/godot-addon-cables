extends Control

@export var death_count_cable: Cable
@onready var _label: Label = $Label

func _ready() -> void:
	var lifetime := NodeWithLifetime.from(self)
	death_count_cable.link_until_destroyed(lifetime, _on_death_count_change)

func _on_death_count_change(count: int) -> void:
	if _label: _label.text = "Deaths: %s" % count
