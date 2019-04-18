extends Node2D

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

# Called when the node enters the scene tree for the first time.
func _ready():
	for sprite in $sprites.get_children():
		if randf()<0.5:
			sprite.set_scale(Vector2(rand_range(0.5, 1.5), rand_range(0.5, 1.5)))
			sprite.set_visible(true)
			sprite.set_frame(randi()%sprite.get_hframes())

		else:
			sprite.set_visible(false)


	set_as_toplevel(true) # don't follow the player
	$AnimationPlayer.play("splat")

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
