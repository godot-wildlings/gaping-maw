extends Area2D

var gravity_radius : float
var accel_radius : float

func _ready() -> void:
	gravity_radius = $GravityRadius.shape.radius
	accel_radius = $AccelerationRadius.shape.radius
	game.black_hole = self
	#warning-ignore:return_value_discarded
	$area.connect("body_entered", self, "on_area_body_entered")
	
	
func on_area_body_entered(body : PhysicsBody2D) -> void:
	if body.is_in_group("Player"):
		get_tree().quit()