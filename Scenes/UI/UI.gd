extends Control
class_name UI

onready var options_panel = $GameOptions/GameOptionsPanel

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
	options_panel.show()
	get_tree().paused = true

func _input(event):
	if Input.is_action_just_pressed("options"):
		if options_panel.visible == false:
			$GameOptions/GameOptionsPanel.show()
			get_tree().paused = true
		else:
			$GameOptions/GameOptionsPanel.hide()
			get_tree().paused = false


func _on_ResumeButton_pressed():
	$GameOptions/GameOptionsPanel.hide()
	get_tree().paused = false


func _on_QuitButton_pressed():
	get_tree().quit()


func _on_GameOptionsPanel_visibility_changed():

	# hack to prevent edge-case bug:
	# when user closes the options panel with the mouse hovering over the audio slider, music continued to play.
	var sample_audio = $GameOptions/GameOptionsPanel/VBoxContainer/HBoxContainer/VBoxContainer/VolSlider/AudioStreamPlayer
	if sample_audio.is_playing() and options_panel.visible == false:
		sample_audio.stop()



func _on_RestartButton_pressed():
	game.main.restart()

