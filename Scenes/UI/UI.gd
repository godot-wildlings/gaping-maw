extends Control
class_name UI

onready var options_panel = $GameOptionsPopupPanel
onready var click_noise = $ClickNoise
onready var hover_noise = $HoverNoise


#onready var progress_bar : ProgressBar = $Panel/GridContainer/ProgressBar
#var progress_value : float

#warning-ignore:unused_signal
#signal progression

func _ready() -> void:
#	game.UI = self
#	progress_value = progress_bar.value
#	self.connect("progression", get_tree().get_root().get_node("/root/game"), "on_Object_Enter")
	pass

func _on_draggable_entered() -> void:
#	progress_value -= 10
	pass



func _on_OptionsButton_pressed():
	click_noise.play()
	yield(click_noise, "finished")

	if options_panel.visible == false:
		options_panel.show()
		get_tree().paused = true
	else:
		options_panel.hide()
		get_tree().paused = false

#warning-ignore:unused_argument
func _input(event):
	if Input.is_action_just_pressed("options"):
		if options_panel.visible == false:
			options_panel.show()
			get_tree().paused = true
		else:
			options_panel.hide()
			get_tree().paused = false


func _on_ResumeButton_pressed():
	click_noise.play()
	yield(click_noise, "finished")


	options_panel.hide()
	get_tree().paused = false


func _on_QuitButton_pressed():
	self.hide()
	game.main.quit_game()

#	click_noise.play()
#	yield(click_noise, "finished")
#
#	$BlackScreen.show()
#	options_panel.hide()
#
#	# for the html version
#
#	get_tree().paused = true
#	$BlackScreen/QuitTimer.start()


func _on_GameOptionsPanel_visibility_changed():

	# hack to prevent edge-case bug:
	# when user closes the options panel with the mouse hovering over the audio slider, music continued to play.
	var sample_audio = $SampleAudio
	if sample_audio.is_playing() and options_panel.visible == false:
		sample_audio.stop()



func _on_RestartButton_pressed():
	click_noise.play()
	yield(click_noise, "finished")

	game.main.restart()

func _on_button_hover():
	hover_noise.play()




func _on_VolSlider_mouse_entered():
	$SampleAudio.play()


func _on_VolSlider_mouse_exited():
	$SampleAudio.stop()



func _on_generic_button_pressed():
	click_noise.play()
	#yield(click_noise, "finished")


func _on_QuitTimer_timeout():
	get_tree().quit()
