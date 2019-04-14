extends Area2D
class_name BlackHole

var gravity_radius : float
var accel_radius : float
onready var EventHorizon = $EventHorizon

signal draggable_entered

func _ready() -> void:
	gravity_radius = $GravityRadius.shape.radius
	accel_radius = $AccelerationRadius.shape.radius
	game.black_hole = self
	call_deferred("deferred_ready")

func deferred_ready() -> void:

	#warning-ignore:return_value_discarded
	EventHorizon.connect("body_entered", self, "_on_EventHorizon_body_entered")
	#warning-ignore:return_value_discarded
	self.connect("draggable_entered", game.UI, "_on_draggable_entered")

	




func _on_EventHorizon_body_entered(body):
	# we could do some progress stuff here if we like.
		# if the black hole is supposed to be destroyable.
	if body.is_in_group("draggable"):
		emit_signal("draggable_entered")
	elif body.is_in_group("Player"):
		get_tree().quit()

	
	if body.has_method("die"):
		body.die()
	else:
		body.call_deferred("queue_free")
