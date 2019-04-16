extends ProgressBar

#warning-ignore:unused_argument
func _process(delta : float) -> void:
	if is_instance_valid(game.player):
		set_value(game.player.oxygen_remaining)
