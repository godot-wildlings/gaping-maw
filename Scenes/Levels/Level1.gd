"""
Spawn planets and asteroids at some frequency.

"""

extends Node2D

var max_spawned_objects : int = 15

func _init():
	game.level = self

func spawn_random_object():
	var asteroid = load("res://Scenes/Obstacles/Asteroid.tscn")
	var planet = load("res://Scenes/Planets/Planet.tscn")
	var object_scenes = [asteroid, planet] # 50/50 chance right now

	var rand_object = object_scenes[randi()%object_scenes.size()]

	var vector_to_black_hole = game.black_hole.get_global_position() - game.player.get_global_position()
	var spawn_distance = 1000
	var base_location = game.player.get_global_position() - vector_to_black_hole.normalized() * spawn_distance
	var deviation = 500
	var rand_location = base_location + Vector2(rand_range(-deviation, deviation), rand_range(-deviation, deviation))

	var new_object = rand_object.instance()
	new_object.set_global_position(rand_location)
	$SpawnedObjects.add_child(new_object)

func spawned_object_count():
	return $SpawnedObjects.get_child_count()


func _on_NewObjectSpawnTimer_timeout():
	if spawned_object_count() < max_spawned_objects:
		spawn_random_object()
