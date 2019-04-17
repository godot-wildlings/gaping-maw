extends HSlider

func _ready() -> void:
	min_value = 0.0001
	step = 0.0001


func _on_VolSlider_mouse_entered():
	if has_node("AudioStreamPlayer"):
		$AudioStreamPlayer.play()


func _on_VolSlider_mouse_exited():
	if has_node("AudioStreamPlayer"):
		$AudioStreamPlayer.stop()




func _on_VolSlider_value_changed(value : float) -> void:
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Master"), log(value) * 20)
