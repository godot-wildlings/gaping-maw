extends CheckButton

func _on_CheckButton_toggled(button_pressed : bool) -> void:
	print(button_pressed)
	OS.set_window_fullscreen(button_pressed)
