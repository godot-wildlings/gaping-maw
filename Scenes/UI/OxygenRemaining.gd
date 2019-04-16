extends ProgressBar

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

#warning-ignore:unused_argument
func _process(delta):
	if is_instance_valid(game.player):
		set_value(game.player.oxygen_remaining)
