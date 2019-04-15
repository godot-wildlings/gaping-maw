extends RigidBody2D
class_name Draggable

export var mouse_drag_speed : float = 4
#export var max_linear_velocity : float = 500
var gravity_radius : float
var is_picked : bool = false
var drag_velocity : Vector2 = Vector2(0,0)

#var mouse_over : bool = false

signal dropped(velocity)

func _ready() -> void:
	#warning-ignore:return_value_discarded
	connect("input_event", self, "on_Draggable_input_event")
	call_deferred("deferred_ready")

	#warning-ignore:return_value_discarded
	connect("mouse_entered", self, "_on_mouse_entered")
	#warning-ignore:return_value_discarded
	connect("mouse_exited", self, "_on_mouse_exited")

func deferred_ready() -> void:
	randomize()
	if game.black_hole:
		gravity_radius = game.black_hole.gravity_radius

	choose_random_image()
	

#warning-ignore:unused_argument
#func _integrate_forces(state : Physics2DDirectBodyState) -> void:
#	if game.black_hole:
#		var distance : float = global_position.distance_to(game.black_hole.global_position)
#		if distance < gravity_radius:
#			applied_force = (game.black_hole.global_position - global_position).normalized() * 50000 / distance

func _integrate_forces(state):
	if is_picked:
		var mousePos = get_global_mouse_position()
		var xForm = state.get_transform()
		var myPos = xForm.get_origin()
		
		drag_velocity = mousePos - myPos
		xForm.origin = mousePos
		state.set_transform(xForm)
		

#warning-ignore:unused_argument
func _physics_process(delta : float) -> void:
#	if is_picked:
#		linear_velocity = get_global_mouse_position() - global_position
#		linear_velocity *= mouse_drag_speed
#		linear_velocity = linear_velocity.clamped(max_linear_velocity)
	pass # allow the physics engine to handle this with a point gravity on the blackhole area2D

#func _input(event : InputEvent) -> void:
#	if mouse_over and Input.is_action_just_pressed("BUTTON_LEFT"):
#		is_picked = true
#		print("picked")
#
#	elif Input.is_action_just_released("BUTTON_LEFT"):
#		is_picked = false

		
#	if _event_is_left_button(event) and not event.pressed:
#		is_picked = false


func choose_random_image() -> void:
	var images : Array = $images.get_children()
	for sprite in images:
		sprite.set_visible(false)
	var randImageNum : int = randi() % images.size()
	images[randImageNum].set_visible(true)


func pickup() -> void:
	# follow the mouse (remember to use physics transforms, not set_position)
	is_picked = true

func drop() -> void:
	# stop following the mouse
	linear_velocity = drag_velocity * mouse_drag_speed
	is_picked = false
	
	#warning-ignore:return_value_discarded
	connect("dropped", game.player, "_on_draggable_dropped")
	emit_signal("dropped", linear_velocity)
	disconnect("dropped", game.player, "_on_draggable_dropped")


#warning-ignore:unused_argument
#warning-ignore:unused_argument
#func on_Draggable_input_event(viewport : Viewport, event : InputEvent, 
#		shape_idx : int) -> void:
#	if _event_is_left_button(event) and event.pressed:
#		is_picked = true
#
#func _event_is_left_button(event : InputEvent) -> bool:
#	#return event is InputEventMouseButton and event.button_index == BUTTON_LEFT
#	if event.is_action_pressed("BUTTON_LEFT"):
#		return true
#	else:
#		return false
		
		
#func _on_mouse_entered():
#	print("mouse_over")
#	mouse_over = true
#
#func _on_mouse_exited():
#	print("mouse_gone")
#	mouse_over = false
#
#func _on_pick_area_mouse_entered():
#	print("mouse_over")
#	mouse_over = true
#
#
#func _on_pick_area_mouse_exited():
#	print("mouse_gone")
#	mouse_over = false
