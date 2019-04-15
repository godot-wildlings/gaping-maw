extends Node2D

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

# Called when the node enters the scene tree for the first time.
func _ready():
	spawn_planets(5)

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func spawn_planets(num):
	print("spawning planet")
	var planet_scene = load("res://Scenes/Planets/Planet.tscn")
	#warning-ignore:unused_variable
	for i in range(num):
		var new_planet = planet_scene.instance()
		var rand_position = Vector2(rand_range(0, 1000), rand_range(1000, 2000))
		new_planet.set_global_position(rand_position)
		add_child(new_planet)
