extends RigidBody2D

export var max_speed : float = 400.0
export var max_health : float = 100.0
export var fling_damper : float = 0.5 # 0 to 1, 1 is maximum thrust
export var oxygen_depletion_per_tick : float = 2.0

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
	$death/Sprite.hide()

func initialize_variables() -> void:
	oxygen_remaining = 100

func die(cause_of_death : String = "") -> void:
	# change this to spawn the lose screen

	$Sprite.hide()
	$death/Sprite.show()

	$Camera2D/Tween._run_death_cam()
	yield(get_node("Camera2D/Tween"),"tween_completed")

	game.main.lose(cause_of_death)

func _on_draggable_dropped(velocity : Vector2) -> void:
	linear_velocity += -velocity * fling_damper
	clamp_linear_velocity()

func _on_creature_dropped(velocity : Vector2) -> void:
	linear_velocity += -velocity * fling_damper
	clamp_linear_velocity()

func clamp_linear_velocity() -> void:
	if linear_velocity.length() > max_speed:
		linear_velocity = linear_velocity.normalized() * max_speed

func spawn_bloodsplat():
	var bloodsplat_scene = preload("res://Scenes/Effects/BloodSplat.tscn")
	var new_bloodsplat = bloodsplat_scene.instance()
	new_bloodsplat.set_global_position(get_global_position())
	$Damage.add_child(new_bloodsplat)



func on_hit(damage : float) -> void:
	health -= int(damage)
	spawn_bloodsplat()
	if health <= 0:
		die("ingestion. Consumed by unknown extradimensional horrors.")

func _on_OxygenTimer_timeout() -> void:
	# remove 1 oxygen unless you're on a planet, then add 10
	if in_atmosphere:
		oxygen_remaining = min(oxygen_remaining + 10, 100)
		$DeepBreathNoise.play()
	else:
		oxygen_remaining = max(oxygen_remaining - oxygen_depletion_per_tick, 0)

	if oxygen_remaining == 0:
		die("asphyxiation in the cold blackness of space.")


func _on_atmosphere_entered() -> void:
	in_atmosphere = true

func _on_atmosphere_left() -> void:
	in_atmosphere = false