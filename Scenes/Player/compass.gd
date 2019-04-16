extends Node2D

#warning-ignore:unused_argument
func _process(delta : float) -> void:
	if game.black_hole != null and is_instance_valid(game.black_hole):
		look_at(game.black_hole.get_position())
