"""
Fly towards the player
Eat cows, trees, houses
Die after eating something

"""

extends Area2D

#export var speed : float = 60.0
export var acceleration : float = 250.0
export var max_speed : float = 500.0

export var turn_speed : float = PI/4 #radians per second

export var DPS : float = 10
export var mouse_drag_speed : float = 4

var is_picked : bool = false
var drag_velocity : Vector2
var velocity : Vector2

func _ready():
	look_at(game.player.get_global_position())

func _process(delta : float) -> void:

	if not is_picked:
		turn_toward_player(delta)
		fly_forward(delta)
	else:
		follow_cursor(delta)

	if game.debug:
		update()

func fly_forward(delta : float) -> void:

	velocity += Vector2.RIGHT.rotated(rotation) * acceleration * delta
	velocity = clamp_velocity(velocity)

	set_global_position(get_global_position() + velocity * delta)


func turn_toward_player(delta : float) -> void:
	# figure out whether to turn left or right (dot product of tangent)
	# change the rotation based on turn speed

	var player_pos = game.player.get_global_position()
	var my_pos = get_global_position()
	var tangent_vector = velocity.normalized().rotated(PI/2)
	var vector_to_player = (player_pos - my_pos).normalized()
	if vector_to_player.dot(tangent_vector) > 0:
		# turn right?
		rotation += turn_speed * delta
	else:
		# turn left?
		rotation -= turn_speed * delta


func clamp_velocity(vel : Vector2) -> Vector2:
	if vel.length() > max_speed:
		return vel.normalized() * max_speed
	else:
		return vel

func follow_cursor(delta : float) -> void:
	var my_pos = get_global_position()
	var mouse_pos = get_global_mouse_position()
	set_global_position(lerp(my_pos, mouse_pos, 0.8))
	drag_velocity = mouse_pos - my_pos


func die() -> void:
	# needs a noise an animation
	call_deferred("queue_free")

func munch(body) -> void:
	# nom nom nom
	if body.has_method("_on_hit"):
		body._on_hit(DPS)
	$MunchNoise.play()
	$MunchTimer.start()

func pickup() -> void:
	# should also play a noise and animation
	is_picked = true


func drop() -> void:
	is_picked = false
	velocity = drag_velocity * mouse_drag_speed


func _on_Creature_body_entered(body : PhysicsBody2D) -> void:
	if body.is_in_group("draggable"):
		if body.has_method("die"):
			body.die()
		else:
			body.queue_free()

		die()
	elif body == game.player:
		munch(body)

func _on_MunchTimer_timeout():
	if get_overlapping_bodies().has(game.player):
		munch(game.player)


func _draw():
	#These two lines should match.
	#draw_line(Vector2.ZERO, velocity * 5.0, Color.purple, true)
	#draw_line(Vector2.ZERO, Vector2.RIGHT.rotated(rotation) * 10, Color.red, true)
	pass
