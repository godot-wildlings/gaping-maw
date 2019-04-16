extends HSlider



# Called when the node enters the scene tree for the first time.
func _ready():
	min_value = 0.0001
	step = 0.0001

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_HSlider_value_changed(value):
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Master"), log(value) * 20)
