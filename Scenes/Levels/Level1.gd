"""
Spawn planets and asteroids at some frequency.

"""

extends Node2D

export var max_spawned_objects : int = 25
var ticks = 0


func spawn_random_object() -> void:
	"""
	Make an asteroid or planet, such that the player is between the black hole and the new object

	Note: the game will get harder as you drift away from the black hole, because planets will be more spread out.
	"""

	var asteroid : PackedScene = load("res://Scenes/Obstacles/Asteroid.tscn")
	var planet : PackedScene = load("res://Scenes/Planets/Planet.tscn")
	var object_scenes : Array = [asteroid, planet] # 50/50 chance right now

	var rand_object : PackedScene= object_scenes[randi() % object_scenes.size()]

	var black_hole_pos = game.black_hole.get_global_position()
	var player_pos = game.player.get_global_position()
	var vector_to_player : Vector2 = player_pos - black_hole_pos
	var rotation_deviation = rand_range(-PI/8, PI/8) # 45 deg
	var distance_deviation = rand_range(1.25, 2.5)

	var spawn_location = black_hole_pos + (vector_to_player * distance_deviation).rotated(rotation_deviation)


	var new_object : Object = rand_object.instance()
	new_object.set_global_position(spawn_location)
	$SpawnedObjects.add_child(new_object)

func spawned_object_count() -> int:
	return $SpawnedObjects.get_child_count()

func cull_distant_objects() -> void:
	for object in $SpawnedObjects.get_children():
		var object_pos = object.get_global_position()
		var player_pos = game.player.get_global_position()
		var hole_pos = game.black_hole.get_global_position()
		var hole_proximity = object_pos.distance_squared_to(hole_pos)
		var max_distance = 500
		var max_proximity = max_distance * max_distance
		if hole_proximity > max_proximity:
			var player_proximity = object_pos.distance_squared_to(player_pos)
			if player_proximity > hole_proximity:
				# black hole is closer than the player.
				object.call_deferred("queue_free")

func _on_NewObjectSpawnTimer_timeout() -> void:
	cull_distant_objects()

	if spawned_object_count() < max_spawned_objects:
		spawn_random_object()


