"""
Spawn planets and asteroids at some frequency.

"""

extends Node2D

export var max_spawned_objects : int = 25

func _init():
	game.level = self

func spawn_random_object() -> void:
	var asteroid : PackedScene = load("res://Scenes/Obstacles/Asteroid.tscn")
	var planet : PackedScene = load("res://Scenes/Planets/Planet.tscn")
	var object_scenes : Array = [asteroid, planet] # 50/50 chance right now

	var rand_object : PackedScene= object_scenes[randi() % object_scenes.size()]

	var vector_to_black_hole : Vector2 = game.black_hole.get_global_position() - game.player.get_global_position()
	var spawn_distance : float = 2500
	var base_location : Vector2 = game.player.get_global_position() - vector_to_black_hole.normalized() * spawn_distance
	var deviation : float = 1250
	var rand_location : Vector2 = base_location + \
			Vector2(rand_range(-deviation, deviation), rand_range(-deviation, deviation))

	var new_object : Object = rand_object.instance()
	new_object.set_global_position(rand_location)
	$SpawnedObjects.add_child(new_object)

func spawned_object_count() -> int:
	return $SpawnedObjects.get_child_count()


func _on_NewObjectSpawnTimer_timeout() -> void:
	if spawned_object_count() < max_spawned_objects:
		spawn_random_object()
