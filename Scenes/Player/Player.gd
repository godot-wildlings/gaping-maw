extends RigidBody2D

export var max_speed : float = 400.0

export var max_health : float = 100.0
var health : int = max_health

var oxygen_remaining : float = 100.0
var in_atmosphere : bool = false

func _init():
	game.player = self

func _ready() -> void:
	call_deferred("deferred_ready")



func deferred_ready() -> void:
#	if game.black_hole:
#		accel_radius = game.black_hole.accel_radius
	$CanvasLayer/UI.show()
	initialize_variables()


func initialize_variables():
	oxygen_remaining = 100

#warning-ignore:unused_argument
func _process(delta) -> void:
	pass # physics moved into bullet engine


func die():
	# change this to spawn the lose screen
	
	$Camera2D/Tween._run_death_cam()
	yield(get_node("Camera2D/Tween"),"tween_completed")
	
	game.main.lose()

func _on_draggable_dropped(velocity):
	linear_velocity += -velocity/4.0
	clamp_linear_velocity()

func _on_creature_dropped(velocity):
	linear_velocity += -velocity/4.0
	clamp_linear_velocity()

func clamp_linear_velocity():
	if linear_velocity.length() > max_speed:
		linear_velocity = linear_velocity.normalized() * max_speed

func _on_hit(damage):
	health -= damage
	if health <= 0:
		
		#zoom camera in on player, then die
		
		#camera.zoom = Vector2(0.3,0.3)
		
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