extends Control
class_name UI

onready var options_panel : PopupPanel = $GameOptionsPopupPanel
onready var click_noise : AudioStreamPlayer = $ClickNoise
onready var hover_noise : AudioStreamPlayer = $HoverNoise

func _on_OptionsButton_pressed() -> void:

	click_noise.play()
	yield(click_noise, "finished")

	if options_panel.visible == false:
		set_option_toggles()
		set_sliders()
		options_panel.show()
		get_tree().paused = true
	else:
		options_panel.hide()
		get_tree().paused = false

func set_option_toggles() -> void:
	var inorganic_enemies_button = find_node("InorganicEnemiesToggle")
	var confine_mouse_button = find_node("ConfineMouseToggle")
	var endless_oxygen_button = find_node("EndlessOxygenToggle")

	if game.options["Creatures_Grabbable"] == true:
		inorganic_enemies_button.pressed = false
	else:
		inorganic_enemies_button.pressed = true

	if Input.get_mouse_mode() == Input.MOUSE_MODE_CONFINED:
		confine_mouse_button.pressed = true
	else:
		confine_mouse_button.pressed = false

	if game.options["Endless_Oxygen"] == true:
		endless_oxygen_button.pressed = true
	else:
		endless_oxygen_button.pressed = false

func set_sliders() -> void:
	var mouse_speed_slider = find_node("MouseSpeedSlider")
	var vol_slider = find_node("VolSlider")
	mouse_speed_slider.set_value(game.options["mouse_drag_speed"])
	vol_slider.set_value(db2linear(AudioServer.get_bus_volume_db(AudioServer.get_bus_index("Master"))))



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

#warning-ignore:unused_argument
func _on_ConfineMouseButton_toggled(button_pressed):
	if Input.get_mouse_mode() == Input.MOUSE_MODE_CONFINED:
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	else:
		Input.set_mouse_mode(Input.MOUSE_MODE_CONFINED)


func _on_InorganicEnemiesCheckbox_toggled(button_pressed):
	if button_pressed == true:
		game.options["Creatures_Grabbable"] = false
	else:
		game.options["Creatures_Grabbable"] = true


func _on_EndlessOxygenToggle_toggled(button_pressed):
	if button_pressed == true:
		game.options["Endless_Oxygen"] = true
	else:
		game.options["Endless_Oxygen"] = false


func _on_MouseSpeedSlider_value_changed(value):
	game.options["mouse_drag_speed"] = value

