"""
Cursor is a targeting reticle which follows the mouse.
It's used to detect mouse-over type events using collision signals

It also has a Path2D which should always go between the cursor position and the player position.
Creatures which latch onto the line can follow the PathFollow2D node.

"""

extends Area2D

#var mouse_over_node : Node2D = null
var object_hooked : Node2D = null

export var max_range : float = 1000.0

enum states { IDLE, HOOKED }
var state = states.IDLE

var time_elapsed : float = 0.0

func _init():
	game.cursor = self

#warning-ignore:unused_argument
func _process(delta : float) -> void:
	time_elapsed += delta
	game.score["Time_Elapsed"] = time_elapsed
	follow_mouse(delta)
	unhook_freed_nodes()
	update() # calls _draw()


func follow_mouse(delta):
	var my_pos : Vector2 = get_global_position()
	var mouse_pos : Vector2 = get_global_mouse_position()
	var player_pos : Vector2 = game.player.get_global_position()

	if player_pos.distance_squared_to(mouse_pos) <= max_range * max_range:
		set_global_position(lerp(my_pos, mouse_pos, 0.8))
	else:
		var vector_to_cursor = (mouse_pos - player_pos).normalized() * max_range
		set_global_position(lerp(my_pos, player_pos + vector_to_cursor, 0.8))


func unhook_freed_nodes():
	if object_hooked != null and is_instance_valid(object_hooked) == false:
		object_hooked = null
		if state == states.HOOKED:
			state = states.IDLE
			$RayGunNoise.stop()
#	if mouse_over_node != null and is_instance_valid(mouse_over_node) == false:
#		mouse_over_node = null




#warning-ignore:unused_argument
func _input(event : InputEvent) -> void:

	if Input.is_action_just_pressed("BUTTON_LEFT"):
		var potential_objects = get_overlapping_bodies()
		if state == states.IDLE:
			if potential_objects.size() > 0:
				grab(potential_objects)

	elif Input.is_action_just_released("BUTTON_LEFT"):
		if state == states.HOOKED and object_hooked != null:
			drop(object_hooked)

func grab(potential_objects):
	for object in potential_objects:
		if object.has_method("pickup"):
			object.pickup()
			state = states.HOOKED
			object_hooked = object
			$RayGunNoise.play()
			return

func drop(object):
	$RayGunNoise.stop()
	if is_instance_valid(object):
		if object.has_method("drop"):
			object.drop()
		object_hooked = null
		state = states.IDLE


#func _on_Cursor_body_entered(body) -> void:
#	if state == states.IDLE:
#		if mouse_over_node == null:
#			if body.is_in_group("draggable"):
#				mouse_over_node = body


#func _on_Cursor_area_entered(area) -> void:
#	if game.options["Creatures_Grabbable"] == false:
#		return
#
#	if state == states.IDLE:
#		if mouse_over_node == null and area.is_in_group("creatures"):
#			var creature = area
#			mouse_over_node = creature
#
#			if game.options["Creatures_Autograb_Hook"] == true:
#				if creature.has_method("pickup"):
#					creature.pickup() # tell the creature to follow the position2d node
#					state = states.HOOKED
#					object_hooked = creature



func _draw() -> void:
	# draw a line between the player and the targeting reticle
	if object_hooked != null and Input.is_action_pressed("BUTTON_LEFT"):
		draw_tether()

func draw_tether():
	var my_pos : Vector2 = to_local(get_global_position())
	var player_pos : Vector2 = to_local(game.player.get_global_position())
	var vector_to_cursor : Vector2 = my_pos - player_pos
	var tangent_vector = vector_to_cursor.normalized().rotated(PI/2)

	var distance : float = vector_to_cursor.length()
	# print(distance) ~ 100 to 500
	var num_segments : float = distance / 5.0
	var amplitude : float = 30
	var frequency : float = 0.2
	var speed : float = 100.0

	var wave_points = []
	#warning-ignore:unused_variable
	for i in range(num_segments):
		var base_distance = distance/num_segments*i
		var base_location = vector_to_cursor/num_segments*i
		var location = player_pos + base_location + (tangent_vector*sin( (time_elapsed*speed + base_distance) * frequency)*amplitude * (1-base_distance/distance))
		wave_points.push_back(location)

	var width : float = 3.0
	var antialias : bool = true

	var i = 0
	var last_pos = player_pos
	for point in wave_points:
		draw_line(last_pos, point, Color.blueviolet, width, antialias)
		last_pos = point

	draw_line(my_pos, player_pos, Color.antiquewhite, width, antialias)


func _on_creature_escaped():
	object_hooked = null

##warning-ignore:unused_argument
#func _on_Cursor_body_exited(body): # draggables
#	mouse_over_node = null


##warning-ignore:unused_argument
#func _on_Cursor_area_exited(area): # creatures
#	mouse_over_node = null
