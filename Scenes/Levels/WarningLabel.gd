extends Label

func _ready() -> void:
	disappear_slowly()

func disappear_slowly() -> void:
	yield(get_tree().create_timer(1.0), "timeout")
	var tween : Tween = get_node("Tween")
	#warning-ignore:return_value_discarded
	tween.interpolate_property(self, "self_modulate",
		Color("feffffff"), Color("00ffffff"), 1,
		Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	#warning-ignore:return_value_discarded
	tween.start()
	yield(tween, "tween_completed")
	call_deferred("queue_free")

