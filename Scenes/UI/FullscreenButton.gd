extends CheckButton

func _ready():
	set_pressed(OS.window_fullscreen)

func _on_FullscreenButton_toggled(button_pressed : bool) -> void:
	OS.set_window_fullscreen(button_pressed)
	if button_pressed:
		Input.set_mouse_mode(Input.MOUSE_MODE_CONFINED)
	else:
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
