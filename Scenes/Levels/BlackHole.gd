extends Area2D
class_name BlackHole

var gravity_radius : float
var accel_radius : float

signal draggable_entered

func _ready() -> void:
	gravity_radius = $GravityRadius.shape.radius
	accel_radius = $AccelerationRadius.shape.radius
	game.black_hole = self
	call_deferred("deferred_ready")

func deferred_ready() -> void:

	#warning-ignore:return_value_discarded
	$area.connect("body_entered", self, "on_area_body_entered")
	#warning-ignore:return_value_discarded
	self.connect("draggable_entered", game.UI, "on_draggable_entered")

func on_area_body_entered(body : PhysicsBody2D) -> void:
	if body.is_in_group("Player"):
		get_tree().quit()
	
	if body.is_in_group("draggable"):
		emit_signal("draggable_entered")