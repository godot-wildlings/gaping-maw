extends Button


func _ready():
	set_pressed(OS.window_fullscreen)


#warning-ignore:unused_argument
func _input(event):
	"""
	# See note about fullscreen at: https://docs.godotengine.org/en/3.0/getting_started/workflow/export/exporting_for_web.html#full-screen-and-mouse-capture
	# To toggle fullscreen on web, you must do it inside _input()
	# It seems like _input() doesn't work if the game is paused.
	# so I had to move the fullscreen button onto the main display, because the options menu pauses the game.
	"""

	if Input.is_action_just_pressed("BUTTON_LEFT"):
#		print("pressed left button")
#		print("rect2 start " , get_rect().position)
#		print("rect2 end " , get_rect().end)
#		print("mouse local position", get_local_mouse_position())

		if is_mouse_over():
			if OS.is_window_fullscreen() == true:
				OS.set_window_fullscreen(false)
				#Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
			else:
				OS.set_window_fullscreen(true)
				#Input.set_mouse_mode(Input.MOUSE_MODE_CONFINED)

func is_mouse_over():
	return get_rect().has_point(get_local_mouse_position())

	update()

func _draw():
	draw_rect(get_rect(), Color.orangered, false)
	draw_circle(get_local_mouse_position(), 10, Color.blue)


