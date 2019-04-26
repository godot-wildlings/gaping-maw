extends RigidBody2D
class_name Draggable

#export var mouse_drag_speed : float = 6.0
#var gravity_radius : float
var is_picked : bool = false
#var drag_velocity : Vector2 = Vector2(0,0)

# only set these during phsyics_process, because you need a fixed framerate.
var last_mouse_pos : Vector2
var current_mouse_pos : Vector2
var framerate_adjusted_mouse_vec : Vector2

signal dropped(velocity)

func _ready() -> void:
	call_deferred("deferred_ready")

func deferred_ready() -> void:
	randomize()
#	if game.black_hole and is_instance_valid(game.black_hole):
#		gravity_radius = game.black_hole.gravity_radius

	choose_random_image()

func _integrate_forces(state : Physics2DDirectBodyState) -> void:
	if is_picked:
		#var mouse_pos : Vector2 = get_global_mouse_position()
		#var mouse_pos = last_mouse_pos
		var x_form : Transform2D = state.get_transform()
		#var my_pos : Vector2 = x_form.get_origin()
		var cursor_pos = game.cursor.get_global_position()

		# **** We're probably going to start getting velocity from the cursor.
		#drag_velocity = framerate_adjusted_mouse_vec

		x_form.origin = cursor_pos
		state.set_transform(x_form)

func _physics_process(delta):
	# physics process is supposed to progress at a fixed frame rate, but it's possible it might slow down

	last_mouse_pos = current_mouse_pos
	current_mouse_pos = get_global_mouse_position()

	var mouse_vec = current_mouse_pos - last_mouse_pos
	var framerate_factor = 1/delta
	framerate_adjusted_mouse_vec = mouse_vec.normalized()*framerate_factor
	# we might need to get the vector length and multiply it by delta




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

func drop(fling_velocity : Vector2) -> void:
	#if fling_velocity == Vector2.ZERO or fling_velocity == null:
		#linear_velocity = drag_velocity * game.options["mouse_drag_speed"]
	#else:
		#linear_velocity = fling_velocity
	linear_velocity = fling_velocity

	is_picked = false
	$WooshNoise.play()

	#warning-ignore:return_value_discarded
	connect("dropped", game.player, "_on_draggable_dropped")
	emit_signal("dropped", linear_velocity)
	disconnect("dropped", game.player, "_on_draggable_dropped")