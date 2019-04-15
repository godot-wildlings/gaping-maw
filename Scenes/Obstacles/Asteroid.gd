extends RigidBody2D

var speed = 200.0

# Called when the node enters the scene tree for the first time.
func _ready():
	linear_velocity = Vector2.UP * speed

