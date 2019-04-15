extends Node2D

#warning-ignore:unused_argument
func _process(delta : float) -> void:
	look_at(game.black_hole.get_position())
