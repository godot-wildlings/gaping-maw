extends Area2D

var mouse_over_node : RigidBody2D

#warning-ignore:unused_argument
func _process(delta : float) -> void:
	var my_pos : Vector2 = get_global_position()
	var mouse_pos : Vector2 = get_global_mouse_position()
	set_global_position(lerp(my_pos, mouse_pos, 0.8))

	update() # calls _draw()

#warning-ignore:unused_argument
func _input(event) -> void:
	if is_instance_valid(mouse_over_node) == false:
		mouse_over_node = null
		return
	
	if Input.is_action_just_pressed("BUTTON_LEFT") and mouse_over_node != null:
		if mouse_over_node.has_method("pickup"):
			mouse_over_node.pickup()
	if Input.is_action_just_released("BUTTON_LEFT") and mouse_over_node != null:
		if is_instance_valid(mouse_over_node):
			if mouse_over_node.has_method("drop"):
				mouse_over_node.drop()
				mouse_over_node = null
		else:
			mouse_over_node = null # probably eaten by the black hole

func _on_Cursor_body_entered(body) -> void:
	if mouse_over_node == null:
		if body.is_in_group("draggable"):
			mouse_over_node = body

func _on_Cursor_body_exited(body) -> void:
	if body == mouse_over_node and Input.is_action_pressed("BUTTON_LEFT") == false:
		mouse_over_node = null

func _draw() -> void:
	# draw a line between the player and the targeting reticle
	if mouse_over_node != null and Input.is_action_pressed("BUTTON_LEFT"):
		var myPos : Vector2 = to_local(get_global_position())
		var playerPos : Vector2 = to_local(game.player.get_global_position())
		var width : float = 3.0
		var antialias : bool = true
		draw_line(myPos, playerPos, Color.antiquewhite, width, antialias)
