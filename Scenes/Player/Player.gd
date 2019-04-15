extends RigidBody2D

#export var max_velocity : float = 1.5
#var velocity : Vector2
#var accel_radius : float

func _init():
	game.player = self
	
func _ready() -> void:
	call_deferred("deferred_ready")

func deferred_ready() -> void:
#	if game.black_hole:
#		accel_radius = game.black_hole.accel_radius
	pass

#warning-ignore:unused_argument
func _process(delta) -> void:
	pass # physics moved into bullet engine
#	if game.black_hole:
#		var distance : float = global_position.distance_to(game.black_hole.global_position)
#		if distance < accel_radius:
#			velocity = (game.black_hole.global_position - global_position).normalized() * max_velocity
#		else:
#			velocity = (game.black_hole.global_position - global_position).normalized() * max_velocity * 0.25
#		position = position + velocity

func die():
	# change this to spawn the lose screen
	game.main.lose()
		
func _on_draggable_dropped(velocity):
	linear_velocity += -velocity/4.0