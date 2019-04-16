extends HSlider

func _ready() -> void:
	min_value = 0.0001
	step = 0.0001

func _on_HSlider_value_changed(value : float) -> void:
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Master"), log(value) * 20)
