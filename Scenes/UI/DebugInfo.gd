extends Label

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


#warning-ignore:unused_argument
func _process(delta):
	var border_margin = 100.0 # pixels


	var debug_text : String = ""

#
	var mouse_pos = get_viewport().get_mouse_position()

	var margin_rect : Rect2 = get_viewport_rect()
	margin_rect.position += Vector2(border_margin, border_margin)
	margin_rect.size -= Vector2(2*border_margin, 2*border_margin)

	if margin_rect.has_point(mouse_pos):
		debug_text = "na na na na"
	else:
		debug_text = "goo-ood bye!"



	set_text(debug_text)


