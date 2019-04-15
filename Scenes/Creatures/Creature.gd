"""
Fly towards the player
Eat cows, trees, houses
Die after eating something

"""

extends Area2D

export var speed : float = 60.0

func _process(delta : float) -> void:
	fly_toward_player(delta)
	
func fly_toward_player(delta : float) -> void:
	var player_pos : Vector2 = game.player.get_global_position()
	var my_pos : Vector2 = get_global_position()
	var vector_to_player : Vector2 = player_pos - my_pos
	
	set_global_position(get_global_position() + vector_to_player.normalized() * speed * delta) 

func die() -> void:
	# needs a noise an animation
	call_deferred("queue_free")

func _on_Creature_body_entered(body : PhysicsBody2D) -> void:
	if body.is_in_group("draggable"):
		if body.has_method("die"):
			body.die()
		else:
			body.queue_free()
		
		die()
