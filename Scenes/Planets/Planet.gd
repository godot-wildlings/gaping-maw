"""
Planets spawn offscreen below the player, then move up towards the black hole.
They should have a bunch of objects on them which players can pick and throw at the black hole.

Question: How do we get rigid bodies to 'stick' to the planet and wait for player to grab them?
"""

extends RigidBody2D

var speed = 200.0


# Called when the node enters the scene tree for the first time.
func _ready():
	spawn_surface_objects()

	linear_velocity = Vector2.UP * speed
	
	

func spawn_surface_objects():
	var num_objects = 7
	var deviation = 3
	var surface_object_scene = load("res://Scenes/Draggable/Draggable.tscn")
	#warning-ignore:unused_variable
	for i in range(randi()%(2*deviation) - deviation + num_objects):
		var new_object = surface_object_scene.instance()
		
		var rand_angle = randf()*2*PI #radians
		var radius = 50.0
		
		new_object.set_position(Vector2.RIGHT.rotated(rand_angle) * radius)
		new_object.set_rotation(rand_angle)

		$surface_objects.add_child(new_object)
