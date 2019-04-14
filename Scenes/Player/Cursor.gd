extends Area2D

var mouse_over_node : RigidBody2D

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var myPos = get_global_position()
	var mousePos = get_global_mouse_position()
	set_global_position(lerp(myPos, mousePos, 0.8))


func _on_Cursor_body_entered(body):
	if body.is_in_group("draggable"):
		mouse_over_node = body

func _input(event):
	if Input.is_action_just_pressed("BUTTON_LEFT") and mouse_over_node != null:
		if mouse_over_node.has_method("pickup"):
			mouse_over_node.pickup()
	if Input.is_action_just_released("BUTTON_LEFT") and mouse_over_node != null:
		if mouse_over_node.has_method("drop"):
			mouse_over_node.drop()


func _on_Cursor_body_exited(body):
	if body == mouse_over_node:
		mouse_over_node = null

