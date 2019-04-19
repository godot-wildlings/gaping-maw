extends Control
class_name UI

onready var options_panel : PopupPanel = $GameOptionsPopupPanel
onready var click_noise : AudioStreamPlayer = $ClickNoise
onready var hover_noise : AudioStreamPlayer = $HoverNoise

func _on_OptionsButton_pressed() -> void:
	click_noise.play()
	yield(click_noise, "finished")

	if options_panel.visible == false:
		options_panel.show()
		get_tree().paused = true
	else:
		options_panel.hide()
		get_tree().paused = false

#warning-ignore:unused_argument
func _input(event : InputEvent) -> void:
	if Input.is_action_just_pressed("options"):
		if options_panel.visible == false:
			options_panel.show()
			get_tree().paused = true
		else:
			options_panel.hide()
			get_tree().paused = false


func _on_ResumeButton_pressed() -> void:
	click_noise.play()
	yield(click_noise, "finished")


	options_panel.hide()
	get_tree().paused = false


func _on_QuitButton_pressed() -> void:
	self.hide()
	game.main.quit_game()

func _on_GameOptionsPanel_visibility_changed() -> void:
	# hack to prevent edge-case bug:
	# when user closes the options panel with the mouse hovering over the audio slider, music continued to play.
	var sample_audio = $SampleAudio
	if sample_audio.is_playing() and options_panel.visible == false:
		sample_audio.stop()

func _on_RestartButton_pressed() -> void:
	click_noise.play()
	yield(click_noise, "finished")

	game.main.restart()

func _on_button_hover() -> void:
	hover_noise.play()

func _on_VolSlider_mouse_entered() -> void:
	$SampleAudio.play()

func _on_VolSlider_mouse_exited() -> void:
	$SampleAudio.stop()

func _on_generic_button_pressed() -> void:
	click_noise.play()

func _on_QuitTimer_timeout():
	get_tree().quit()