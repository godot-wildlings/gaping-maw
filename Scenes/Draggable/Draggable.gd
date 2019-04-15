extends RigidBody2D
class_name Draggable

export var mouse_drag_speed : float = 4
var gravity_radius : float
var is_picked : bool = false
var drag_velocity : Vector2 = Vector2(0,0)


signal dropped(velocity)

func _ready() -> void:
	call_deferred("deferred_ready")

func deferred_ready() -> void:
	randomize()
	if game.black_hole:
		gravity_radius = game.black_hole.gravity_radius

	choose_random_image()

func _integrate_forces(state : Physics2DDirectBodyState) -> void:
	if is_picked:
		var mouse_pos : Vector2 = get_global_mouse_position()
		var x_form : Transform2D = state.get_transform()
		var my_pos : Vector2 = x_form.get_origin()

		drag_velocity = mouse_pos - my_pos
		x_form.origin = mouse_pos
		state.set_transform(x_form)


func choose_random_image() -> void:
	var images : Array = $images.get_children()
	for sprite in images:
		sprite.set_visible(false)
	var randImageNum : int = randi() % images.size()
	images[randImageNum].set_visible(true)


func pickup() -> void:
	# follow the mouse (remember to use physics transforms, not set_position)
	is_picked = true
	$SquishNoise.play()
	$AnimationPlayer.play("bounce")

func drop() -> void:
	# stop following the mouse
	linear_velocity = drag_velocity * mouse_drag_speed
	is_picked = false
	$WooshNoise.play()

	#warning-ignore:return_value_discarded
	connect("dropped", game.player, "_on_draggable_dropped")
	emit_signal("dropped", linear_velocity)
	disconnect("dropped", game.player, "_on_draggable_dropped")