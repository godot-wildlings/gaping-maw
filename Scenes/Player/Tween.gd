extends Tween

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

# Called when the node enters the scene tree for the first time.
func _ready():
	interpolate_property(get_parent(), "zoom",get_parent().get_zoom(), Vector2(0.3,0.3), 1,Tween.TRANS_LINEAR, Tween.EASE_OUT)

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
func _run_death_cam():
	
	start()