extends Node2D

onready var planet_scene : PackedScene = preload("res://Scenes/Planets/Planet.tscn")

func spawn_planets(num : int) -> void:
	#warning-ignore:unused_variable
	for i in range(num):
		var new_planet : Object = planet_scene.instance()
		var rand_position : Vector2 = Vector2(rand_range(0, 1000), rand_range(1000, 2000))
		new_planet.set_global_position(rand_position)
		add_child(new_planet)
