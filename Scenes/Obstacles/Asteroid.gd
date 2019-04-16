extends RigidBody2D

export var speed : float = 200.0

func _ready() -> void:
	var vector_to_black_hole = game.black_hole.get_global_position() - get_global_position()
	linear_velocity = vector_to_black_hole.normalized() * speed

