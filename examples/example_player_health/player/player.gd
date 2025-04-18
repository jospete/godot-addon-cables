class_name Player extends Node2D

@export var max_health: float = 100.0
@export var damage_value: float = 25.0
@export var damage_action: StringName = "action1"

@export var health_value_cable: Cable
@export var health_ratio_value_cable: Cable
@export var death_event_cable: Cable
@export var death_count_cable: Cable

var health: float

func _ready() -> void:
	health = max_health

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed(damage_action):
		take_damage(damage_value)

func take_damage(damage: float) -> void:
	var new_health = clamp(health - abs(damage), 0.0, max_health)
	
	if new_health == health:
		return
	
	health = new_health
	var ratio := health / max_health
	var dead := health <= 0.0
	
	health_value_cable.notify(health)
	health_ratio_value_cable.notify(ratio)
	
	if dead:
		death_event_cable.void_notify()
		var updated_death_count = death_count_cable.get_value_or_default(0) + 1
		death_count_cable.notify(updated_death_count)
