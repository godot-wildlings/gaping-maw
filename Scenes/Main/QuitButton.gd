extends Button

func _on_QuitButton_pressed() -> void:
	var click_noise = get_parent().get_node("ClickNoise")
	click_noise.play()
	yield(click_noise, "finished")
	#get_tree().quit()
	game.main.quit_game()


func _on_button_hover():
	var hover_noise = get_parent().get_node("HoverNoise")
	hover_noise.play()