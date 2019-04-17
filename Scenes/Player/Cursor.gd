"""
Cursor is a targeting reticle which follows the mouse.
It's used to detect mouse-over type events using collision signals

It also has a Path2D which should always go between the cursor position and the player position.
Creatures which latch onto the line can follow the PathFollow2D node.

"""

extends Area2D

var mouse_over_node : Node2D = null
export var max_range : float = 1000.0

enum states { IDLE, HOOKED }
var state = states.IDLE

func _init():
	game.cursor = self

#warning-ignore:unused_argument
func _process(delta : float) -> void:
	var my_pos : Vector2 = get_global_position()
	var mouse_pos : Vector2 = get_global_mouse_position()
	var player_pos : Vector2 = game.player.get_global_position()

	if player_pos.distance_squared_to(mouse_pos) <= max_range * max_range:
		set_global_position(lerp(my_pos, mouse_pos, 0.8))
	else:
		var vector_to_cursor = (mouse_pos - player_pos).normalized() * max_range
		set_global_position(lerp(my_pos, player_pos + vector_to_cursor, 0.8))

	update() # calls _draw()


#warning-ignore:unused_argument
func _input(event : InputEvent) -> void:
	if is_instance_valid(mouse_over_node) == false:
		mouse_over_node = null
		return



	if Input.is_action_just_pressed("BUTTON_LEFT"):
		if mouse_over_node != null:

			if mouse_over_node.is_in_group("draggable"):
				if mouse_over_node.has_method("pickup"):
					mouse_over_node.pickup()
					state = states.HOOKED
			elif mouse_over_node.is_in_group("creatures"):
				if game.options["Creatures_Autograb_Hook"] == false:
					if mouse_over_node.has_method("pickup"):
						mouse_over_node.pickup()
						state = states.HOOKED


	if Input.is_action_just_released("BUTTON_LEFT"):
		if mouse_over_node != null:
			if is_instance_valid(mouse_over_node):
				#print("Cursor.gd thinks mouse_over_node is: ", mouse_over_node)
				if mouse_over_node.is_in_group("draggable") or mouse_over_node.is_in_group("creatures"):
					if mouse_over_node.has_method("drop"):
						mouse_over_node.drop()
						mouse_over_node = null
						state = states.IDLE
			else:
				mouse_over_node = null # probably eaten by the black hole
				state = states.IDLE


func _on_Cursor_body_entered(body) -> void:
	if state == states.IDLE:
		if mouse_over_node == null:
			if body.is_in_group("draggable"):
				mouse_over_node = body


func _on_Cursor_area_entered(area) -> void:
	if game.options["Creatures_Grabbable"] == false:
		return

	if state == states.IDLE:
		if mouse_over_node == null and area.is_in_group("creatures"):
			mouse_over_node = area

			if game.options["Creatures_Autograb_Hook"] == true:
				if area.has_method("pickup"):
					area.pickup() # tell the creature to follow the position2d node
					state = states.HOOKED



func _draw() -> void:
	# draw a line between the player and the targeting reticle
	if mouse_over_node != null and Input.is_action_pressed("BUTTON_LEFT"):
		var myPos : Vector2 = to_local(get_global_position())
		var playerPos : Vector2 = to_local(game.player.get_global_position())
		var width : float = 3.0
		var antialias : bool = true
		draw_line(myPos, playerPos, Color.antiquewhite, width, antialias)

func _on_creature_escaped():
	mouse_over_node = null


#warning-ignore:unused_argument
func _on_Cursor_body_exited(body): # draggables
	if state == states.IDLE:
		mouse_over_node = null


#warning-ignore:unused_argument
func _on_Cursor_area_exited(area): # creatures
	if state == states.IDLE:
		mouse_over_node = null
