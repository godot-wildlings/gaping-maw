extends KinematicBody2D

var velocity : Vector2
var max_velocity : float = 1.5
var accel_radius : float

func _ready() -> void:
	call_deferred("deferred_ready")

func deferred_ready() -> void:
	if game.black_hole:
		accel_radius = game.black_hole.gravity_radius

func _process(delta) -> void:
	if game.black_hole:
		var distance : float = global_position.distance_to(game.black_hole.global_position)
		if distance < accel_radius:
			print("in")
			velocity = (game.black_hole.global_position - global_position).normalized() * max_velocity
		else:
			velocity = (game.black_hole.global_position - global_position).normalized() * max_velocity * 0.25
		position = position + velocity