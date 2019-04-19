extends Button

onready var click_noise  : AudioStreamPlayer = get_parent().get_node("ClickNoise")
onready var hover_noise  : AudioStreamPlayer = get_parent().get_node("HoverNoise")

func _on_StartButton_pressed() -> void:
	click_noise.play()
	yield(click_noise, "finished")

	game.main.restart()

func _on_StartButton_mouse_entered() -> void:
	hover_noise.play()