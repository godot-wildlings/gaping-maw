extends Label

#warning-ignore:unused_argument
func _process(delta : float) -> void:
	set_text("Planets Destroyed: " + str(game.planets_destroyed))