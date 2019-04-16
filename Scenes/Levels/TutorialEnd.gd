"""
Quick script to end the current (tutorial) level when the win-condition is met.
Usually that will be a RigidBody2D entering an Area2d

"""

extends Area2D



# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Antimatter_body_entered(body):
	if body != game.player:
		$CollisionShape2D.call_deferred("set_disabled", true)
		game.main.next_level()
		call_deferred("queue_free")

