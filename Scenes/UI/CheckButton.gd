extends CheckButton

func _ready():
	set_pressed(OS.window_fullscreen)

func _on_CheckButton_toggled(button_pressed : bool) -> void:
	print(button_pressed)
	OS.set_window_fullscreen(button_pressed)
