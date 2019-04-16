extends RigidBody2D

export var max_speed : float = 400.0
export var max_health : float = 100.0

var health : int = max_health
var oxygen_remaining : float = 100.0
var in_atmosphere : bool = false

func _init() -> void:
	game.player = self

func _ready() -> void:
	call_deferred("deferred_ready")

func deferred_ready() -> void:
#	if game.black_hole:
#		accel_radius = game.black_hole.accel_radius
	$CanvasLayer/UI.show()
	initialize_variables()


func initialize_variables() -> void:
	oxygen_remaining = 100

func die() -> void:
	# change this to spawn the lose screen
	$Camera2D/Tween._run_death_cam()
	yield(get_node("Camera2D/Tween"),"tween_completed")
	
	game.main.lose()

func _on_draggable_dropped(velocity : Vector2) -> void:
	linear_velocity += -velocity / 4.0
	clamp_linear_velocity()

func _on_creature_dropped(velocity : Vector2) -> void:
	linear_velocity += -velocity / 4.0
	clamp_linear_velocity()

func clamp_linear_velocity() -> void:
	if linear_velocity.length() > max_speed:
		linear_velocity = linear_velocity.normalized() * max_speed

func on_hit(damage):
	health -= damage
	if health <= 0:
		die()

func _on_OxygenTimer_timeout():
	# remove 1 oxygen unless you're on a planet, then add 10
	if in_atmosphere:
		oxygen_remaining = clamp(oxygen_remaining + 10, 0, 100)
		$DeepBreathNoise.play()
	else:
		oxygen_remaining = clamp(oxygen_remaining - 1, 0, 100)

	if oxygen_remaining == 0:
		die()


func _on_atmosphere_entered():
	in_atmosphere = true

func _on_atmosphere_left():
	in_atmosphere = false