extends Button

onready var click_noise  : AudioStreamPlayer = get_parent().get_node("ClickNoise")
onready var hover_noise  : AudioStreamPlayer = get_parent().get_node("HoverNoise")

func _on_QuitButton_pressed() -> void:
	click_noise.play()
	yield(click_noise, "finished")
	#get_tree().quit()
	game.main.quit_game()

func _on_button_hover() -> void:
	hover_noise.play()