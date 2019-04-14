extends Node2D

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

# Called when the node enters the scene tree for the first time.
func _ready():
	var stars = get_children()
	
	for star in stars:
		star.set_modulate(Color(1, 1, 1, randf()))
		var randPosition = Vector2(rand_range(-100, 100), rand_range(-100, 100))
		star.set_position(randPosition)
		var randScale = rand_range(0.1, 3.0)
		star.set_scale(Vector2(randScale, randScale))
		star.set_rotation(randf()*2*PI)
		if randf()<0.25:
			hide()

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
