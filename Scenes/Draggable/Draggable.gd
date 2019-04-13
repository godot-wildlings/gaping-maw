extends RigidBody2D

export var mouse_drag_speed : float = 4
export var max_linear_velocity : float = 500
var gravity_radius : float
var is_picked : bool = false

func _ready() -> void:
	#warning-ignore:return_value_discarded
	connect("input_event", self, "on_Draggable_input_event")
	call_deferred("deferred_ready")

func deferred_ready() -> void:
	if game.black_hole:
		gravity_radius = game.black_hole.gravity_radius

func _integrate_forces(state : Physics2DDirectBodyState):
	if game.black_hole:
		var distance : float = global_position.distance_to(game.black_hole.global_position)
		if distance < gravity_radius:
			applied_force = (game.black_hole.global_position - global_position).normalized() * 50000 / distance

#warning-ignore:unused_argument
func _physics_process(delta : float) -> void:
	if is_picked:
		linear_velocity = get_global_mouse_position() - global_position
		linear_velocity *= mouse_drag_speed
		linear_velocity = linear_velocity.clamped(max_linear_velocity)

func _input(event : InputEvent) -> void:
	if _event_is_left_button(event) and not event.pressed:
		is_picked = false

#warning-ignore:unused_argument
#warning-ignore:unused_argument
func on_Draggable_input_event(viewport : Viewport, event : InputEvent, 
		shape_idx : int) -> void:
	if _event_is_left_button(event) and event.pressed:
		is_picked = true

func _event_is_left_button(event : InputEvent) -> bool:
	return event is InputEventMouseButton and event.button_index == BUTTON_LEFT
