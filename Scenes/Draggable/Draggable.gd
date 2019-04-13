extends RigidBody2D

export var mouse_drag_speed : float = 4
export var max_linear_velocity : float = 500

var is_picked : bool = false

func _ready() -> void:
	#warning-ignore:return_value_discarded
	connect("input_event", self, "on_Draggable_input_event")

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
