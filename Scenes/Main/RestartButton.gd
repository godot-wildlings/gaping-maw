extends Button

func _on_RestartButton_pressed() -> void:
	var click_noise = get_parent().get_node("ClickNoise")
	click_noise.play()
	yield(click_noise, "finished")

	game.main.restart()

func _on_button_hover():
	var hover_noise = get_parent().get_node("HoverNoise")
	hover_noise.play()