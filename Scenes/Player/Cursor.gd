extends Area2D

var mouse_over_node : RigidBody2D

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
#warning-ignore:unused_argument
func _process(delta):
	var myPos = get_global_position()
	var mousePos = get_global_mouse_position()
	set_global_position(lerp(myPos, mousePos, 0.8))

	update()


#warning-ignore:unused_argument
func _input(event):
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

func _on_Cursor_body_entered(body):
	if body.is_in_group("draggable"):
		mouse_over_node = body

func _on_Cursor_body_exited(body):
	if body == mouse_over_node and Input.is_action_pressed("BUTTON_LEFT") == false:
		mouse_over_node = null

func _draw():
	if mouse_over_node != null and Input.is_action_pressed("BUTTON_LEFT"):
		var myPos = to_local(get_global_position())
		var playerPos = to_local(game.player.get_global_position())
		var width = 3.0
		var antialias = true
		draw_line(myPos, playerPos, Color.antiquewhite, width, antialias)
