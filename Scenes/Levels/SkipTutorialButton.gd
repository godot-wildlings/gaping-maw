extends Button

func _on_SkipTutorialButton_pressed() -> void:
	$ClickNoise.play()
	yield($ClickNoise, "finished")
	game.main.skip_tutorial()


func _on_button_hover() -> void:
	$HoverNoise.play()
