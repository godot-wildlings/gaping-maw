extends RigidBody2D

export var speed : float = 200.0

func _ready() -> void:
	if game.black_hole != null and is_instance_valid(game.black_hole):
		var vector_to_black_hole : Vector2 = game.black_hole.get_global_position() - get_global_position()
		linear_velocity = vector_to_black_hole.normalized() * speed

