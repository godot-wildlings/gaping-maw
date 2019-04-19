"""
Spawn planets and asteroids at some frequency.

"""

extends Node2D

export var max_spawned_objects : int = 25


func spawn_random_object() -> void:
	"""
	Make an asteroid or planet, such that the player is between the black hole and the new object

	Note: the game will get harder as you drift away from the black hole, because planets will be more spread out.
	"""

	var asteroid : PackedScene = load("res://Scenes/Obstacles/Asteroid.tscn")
	var planet : PackedScene = load("res://Scenes/Planets/Planet.tscn")
	#var object_scenes : Array = [asteroid, planet] # 50/50 chance right now

	var rand_object : PackedScene
	if randf() < 0.66:
		rand_object = asteroid
	else:
		rand_object = planet

	var black_hole_pos : Vector2 = game.black_hole.get_global_position()
	var player_pos : Vector2 = game.player.get_global_position()
	var vector_to_player : Vector2 = player_pos - black_hole_pos
	var direction_vector : Vector2 = vector_to_player.normalized()
	var distance_to_player : float = vector_to_player.length()
	var rotation_deviation : float = rand_range(-PI / 8, PI / 8) # 45 deg
	var distance : float = distance_to_player + rand_range(2000, 4000)
	var spawn_location : Vector2 = black_hole_pos + direction_vector.rotated(rotation_deviation) * distance
	var new_object : Object = rand_object.instance()
	
	new_object.set_global_position(spawn_location)
	$SpawnedObjects.add_child(new_object)

func spawned_object_count() -> int:
	return $SpawnedObjects.get_child_count()

func cull_distant_objects() -> void:
	for object in $SpawnedObjects.get_children():
		var object_pos : Vector2 = object.get_global_position()
		var player_pos : Vector2 = game.player.get_global_position()
		var hole_pos : Vector2 = game.black_hole.get_global_position()
		var hole_proximity : float = object_pos.distance_squared_to(hole_pos)
		var max_distance : float = 1500
		var max_proximity : float = max_distance * max_distance
		if hole_proximity > max_proximity:
			var player_proximity : float = object_pos.distance_squared_to(player_pos)
			if player_proximity > hole_proximity:
				# black hole is closer than the player.
				object.call_deferred("queue_free")

func _on_NewObjectSpawnTimer_timeout() -> void:
	cull_distant_objects()

	if spawned_object_count() < max_spawned_objects:
		spawn_random_object()


