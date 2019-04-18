extends CheckButton

func _ready():
	set_pressed(OS.window_fullscreen)

func _on_FullscreenButton_toggled(button_pressed : bool) -> void:

	var click_noise = get_parent().get_node("ClickNoise")


	click_noise.play()
	yield(click_noise, "finished")

	OS.set_window_fullscreen(button_pressed)
	if button_pressed:
		Input.set_mouse_mode(Input.MOUSE_MODE_CONFINED)
	else:
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)


func _on_FullscreenButton_mouse_entered():
	var hover_noise = get_parent().get_node("HoverNoise")
	hover_noise.play()
