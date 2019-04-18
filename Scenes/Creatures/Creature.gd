"""
Fly towards the player
Eat cows, trees, houses
Die after eating something

If the creature gets on your hook, it should crawl along the line until it eats you.
The only way to get rid of it then will be to feed it something else.
"""

extends Area2D

#export var speed : float = 60.0
export var acceleration : float = 350.0 # per second.. will be reduced by delta
export var max_speed : float = 350.0


#export var crawl_speed : float = 200.0

export var turn_speed : float = PI/4 #radians per second

export var DPS : float = 10
export var mouse_drag_speed : float = 8

enum states { FLYING, EATING, TETHERED, CRAWLING, DEAD }
#warning-ignore:unused_class_variable
var state = states.FLYING

var is_picked : bool = false
var drag_velocity : Vector2
var velocity : Vector2

var target : Node2D

var grapple_line : Path2D

signal dropped(vel)

func _ready():
	choose_random_target()
	look_at(target.get_global_position())


func choose_random_target():
	var planets = get_tree().get_nodes_in_group("planets")
	if planets.size() == 0 or randf() < 0.66:
		target = game.player
	else:
		target = planets[randi()%planets.size()]

func _process(delta : float) -> void:
	if is_instance_valid(target) == false:
		choose_random_target()

	if state == states.FLYING:
		turn_toward_target(delta)
		accelerate_if_on_target(delta)
		fly_forward(delta)
	elif state == states.TETHERED: # creature on the hook. Player has limited time to fling/drop them
		follow_cursor(delta)
	elif state == states.CRAWLING: # creature is crawling the line. player can't drop them anymore
		crawl_toward_player(delta)

	if game.debug:
		update()

#warning-ignore:unused_argument
func crawl_toward_player(delta) -> void:
	# keep the creature on the line between player and cursor.
	var my_pos = get_global_position()
	var target_pos = grapple_line.get_target_position()
	set_global_position(lerp(my_pos, target_pos, 0.8))

func fly_forward(delta : float) -> void:
	velocity = clamp_velocity(velocity)
	set_global_position(get_global_position() + velocity * delta)

func accelerate_if_on_target(delta):
	var my_pos = get_global_position()
	var target_pos = game.player.get_global_position()
	var vector_to_target = target_pos - my_pos
	var forward_vector = Vector2.RIGHT.rotated(rotation)
	if vector_to_target.dot(forward_vector) > 0: # within 90deg
		velocity += Vector2.RIGHT.rotated(rotation) * acceleration * delta


func turn_toward_target(delta : float) -> void:
	# figure out whether to turn left or right (dot product of tangent)
	# change the rotation based on turn speed

	var target_pos = target.get_global_position()
	var my_pos = get_global_position()
	var tangent_vector = velocity.normalized().rotated(PI/2)
	var vector_to_target = (target_pos - my_pos).normalized()
	if vector_to_target.dot(tangent_vector) > 0:
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

#warning-ignore:unused_argument
func follow_cursor(delta : float) -> void:
	var my_pos = get_global_position()
	var mouse_pos = get_global_mouse_position()
	set_global_position(lerp(my_pos, mouse_pos, 0.8))
	drag_velocity = mouse_pos - my_pos


	var drag_speed = drag_velocity.length()
	var drag_rot = Vector2.UP.angle_to(drag_velocity)
	rotation = lerp_angle(rotation, drag_rot, 0.1)
	#look_at(my_pos + drag_velocity)

	var stretch_reduction_factor = 50
	$Sprite.scale.y = min(1 + drag_speed/stretch_reduction_factor, 1.5)
	$Sprite.scale.x = max(1 - drag_speed/stretch_reduction_factor, 0.3)

func lerp_angle(from, to, weight) -> float:
    return from + short_angle_dist(from, to) * weight

func short_angle_dist(from, to) -> float:
    var max_angle = PI * 2
    var difference = fmod(to - from, max_angle)
    return fmod(2 * difference, max_angle) - difference


func die() -> void:
	state = states.DEAD
	# needs a noise an animation
	velocity *= 0.1 # slow down, but don't stop altogether
	$AnimationPlayer.play("pop")
	yield($AnimationPlayer, "animation_finished")
	game.score["Creatures_Destroyed"] += 1
	call_deferred("queue_free")

func munch(body) -> void:
	state = states.EATING
	# nom nom nom
	velocity *= 0.3 # slow down, but don't stop altogether

	if body.has_method("on_hit"):
		body.on_hit(DPS)
	$AnimationPlayer.play("munch")
	$MunchNoise.play()
	$MunchTimer.start()

func pickup() -> void:
	if game.options["Creatures_Grabbable"] == false:
		return


	# should also play a noise and animation
	if state == states.FLYING or state == states.EATING:
		state = states.TETHERED
		$AnimationPlayer.play("drag")
		$EscapeHookTimer.start()

	if game.options["Creatures_Walk_The_Line"] == true:
		var grapple_line_scene = load("res://Scenes/Creatures/CreatureCrawlLine.tscn")
		var new_grapple = grapple_line_scene.instance()
		add_child(new_grapple)
		grapple_line = new_grapple



func drop() -> void:
	# player has a limited time to fling a creature.
	if state == states.TETHERED:
		state = states.FLYING
		$AnimationPlayer.play("idle")
		velocity = drag_velocity * mouse_drag_speed

	#warning-ignore:return_value_discarded
	connect("dropped", game.player, "_on_creature_dropped")
	emit_signal("dropped", velocity)
	disconnect("dropped", game.player, "_on_creature_dropped")


func _on_Creature_body_entered(body : PhysicsBody2D) -> void:
	if state == states.DEAD:
		return

	if body.is_in_group("draggable"):
		if body.has_method("die"):
			body.die()
		else:
			body.queue_free()

		die()
	elif body == game.player:
		munch(body)
	elif body.is_in_group("planets"):
		munch(body)


func _on_MunchTimer_timeout():
	if get_overlapping_bodies().has(game.player):
		munch(game.player)


func _draw():
	#These two lines should match.
	#draw_line(Vector2.ZERO, velocity * 5.0, Color.purple, true)
	#draw_line(Vector2.ZERO, Vector2.RIGHT.rotated(rotation) * 10, Color.red, true)
	pass


func _on_EscapeHookTimer_timeout():
	# should play a happy noise.. the creature got free. it's now approaching the player


	if state == states.TETHERED:

		if game.options["Creatures_Walk_The_Line"]:
			state = states.CRAWLING

			game.cursor._on_creature_escaped()
