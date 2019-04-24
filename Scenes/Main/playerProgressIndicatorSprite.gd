"""
A little sprite that goes to the value position on a parent progress bar
"""

extends Sprite

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

#warning-ignore:unused_argument
func _process(delta):
	var progress_bar = get_parent()

	#position.x = progress_bar.get_rect().position.x + progress_bar.value/progress_bar.get_rect().size.x
