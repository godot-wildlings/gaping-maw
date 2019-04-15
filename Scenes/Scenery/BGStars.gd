extends Node2D

func _ready() -> void:
	var stars : Array = get_children()
	
	for star in stars:
		star.set_modulate(Color(1, 1, 1, randf()))
		var randPosition = Vector2(rand_range(-100, 100), rand_range(-100, 100))
		star.set_position(randPosition)
		var randScale = rand_range(0.1, 3.0)
		star.set_scale(Vector2(randScale, randScale))
		star.set_rotation(randf()*2*PI)
		if randf()<0.25:
			hide()