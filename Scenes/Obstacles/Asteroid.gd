extends RigidBody2D

var speed = 200.0

# Called when the node enters the scene tree for the first time.
func _ready():
	var vector_to_black_hole = game.black_hole.get_global_position() - get_global_position()
	linear_velocity = vector_to_black_hole.normalized() * speed

