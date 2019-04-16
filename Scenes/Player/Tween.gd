extends Tween

func _ready() -> void:
	#warning-ignore:return_value_discarded
	interpolate_property(get_parent(), "zoom",get_parent().get_zoom(), \
			Vector2(0.3, 0.3), 1, Tween.TRANS_LINEAR, Tween.EASE_OUT)

func _run_death_cam() -> void:
	#warning-ignore:return_value_discarded
	start()