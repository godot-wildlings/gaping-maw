extends Label

#warning-ignore:unused_argument
func _process(delta : float) -> void:
	set_text(str(game.planets_destroyed))