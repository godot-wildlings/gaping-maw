"""
Fly towards the player
Eat cows, trees, houses
Die after eating something

"""

extends Area2D

var speed = 60.0

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	fly_toward_player(delta)
	

func fly_toward_player(delta):
	
	var playerPos = game.player.get_global_position()
	var myPos = get_global_position()
	var vector_to_player = playerPos - myPos
	
	set_global_position(get_global_position() + vector_to_player.normalized() * speed * delta) 

func die():
	# needs a noise an animation
	call_deferred("queue_free")

func _on_Creature_body_entered(body):
	if body.is_in_group("draggable"):
		if body.has_method("die"):
			body.die()
		else:
			body.queue_free()
		
		die()
