extends Node2D

func _ready() -> void:
	for sprite in $sprites.get_children():
		if randf() < 0.5:
			sprite.set_scale(Vector2(rand_range(0.5, 1.5), rand_range(0.5, 1.5)))
			sprite.set_visible(true)
			sprite.set_frame(randi() % sprite.get_hframes())
		else:
			sprite.set_visible(false)

	set_as_toplevel(true) # don't follow the player
	$AnimationPlayer.play("splat")