extends Label

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

# Called when the node enters the scene tree for the first time.
func _ready():
	disappear_slowly()


func disappear_slowly():
	yield(get_tree().create_timer(1.0), "timeout")
	var tween = get_node("Tween")
	tween.interpolate_property(self, "self_modulate",
		Color("feffffff"), Color("00ffffff"), 1,
		Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	tween.start()
	yield(tween, "tween_completed")
	call_deferred("queue_free")

