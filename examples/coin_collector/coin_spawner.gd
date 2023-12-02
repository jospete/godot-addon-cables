class_name CoinSpawner extends Node2D

@export var coin_prefab: PackedScene
@export var spawn_radius: float = 5.0

var _rng = RandomNumberGenerator.new()

func spawn():
	var coin: Coin = coin_prefab.instantiate()
	add_child(coin)
	
	var offset_x = _rng.randf_range(-spawn_radius, spawn_radius)
	var offset_y = _rng.randf_range(-spawn_radius, spawn_radius)
	var offset = Vector2(offset_x, offset_y)
	
	coin.position = offset
