"""
Quick script to end the current (tutorial) level when the win-condition is met.
Usually that will be a RigidBody2D entering an Area2d

"""

extends Area2D

func _on_Antimatter_body_entered(body : PhysicsBody2D):
	if body != game.player:
		$CollisionShape2D.call_deferred("set_disabled", true)
		game.main.next_level()
		call_deferred("queue_free")