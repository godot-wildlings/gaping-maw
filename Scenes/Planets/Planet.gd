"""
Planets spawn offscreen below the player, then move up towards the black hole.
They should have a bunch of objects on them which players can pick and throw at the black hole.

Question: How do we get rigid bodies to 'stick' to the planet and wait for player to grab them?
"""

extends RigidBody2D

export var speed : float = 200.0
export var max_health : int = 30
var health : int = max_health


func _ready() -> void:
	var vector_to_black_hole : Vector2 = game.black_hole.get_global_position() - get_global_position()
	linear_velocity = vector_to_black_hole.normalized() * speed
	spawn_surface_objects()

func spawn_surface_objects() -> void:
	var num_objects : int = 7
	var deviation : int = 3
	var surface_object_scene : PackedScene = load("res://Scenes/Draggable/Draggable.tscn")
	#warning-ignore:unused_variable
	for i in range(randi() % (2 * deviation) - deviation + num_objects):
		var new_object : Object = surface_object_scene.instance()
		var rand_angle : float = randf() * 2 * PI #radians
		var radius : float = 50.0

		new_object.set_as_toplevel(true)

		new_object.set_global_position(get_global_position() + Vector2.RIGHT.rotated(rand_angle) * radius)
		new_object.set_rotation(rand_angle)

		$surface_objects.add_child(new_object)
		new_object.linear_velocity = get_linear_velocity()

func die() -> void:
	# update the score, then disappear
	#game.planets_destroyed += 1
	game.score["Planets_Lost"] += 1
	call_deferred("queue_free")

func on_hit(damage : float) -> void:
	health -= int(damage)
	if health <= 0:
		die()

func _on_GravityWell_body_entered(body : PhysicsBody2D) -> void:
	if body == game.player:
		if body.has_method("_on_atmosphere_entered"):
			body._on_atmosphere_entered()

func _on_GravityWell_body_exited(body : PhysicsBody2D) -> void:
	if body == game.player:
		if body.has_method("_on_atmosphere_left"):
			body._on_atmosphere_left()