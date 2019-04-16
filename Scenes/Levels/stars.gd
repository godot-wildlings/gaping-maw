extends Node2D

export var speed : float = 25.0
export var extents : Vector2 = Vector2(1000, 1000)


func _ready() -> void:
	spawn_stars()

func spawn_stars() -> void:
	var stars_container : Node2D = self
	var star_scene : PackedScene = load("res://Scenes/Scenery/BGStars.tscn")
	var width : float = 1500
	var height : float = 1500
	randomize()

	#warning-ignore:unused_variable
	for i in range(250):
		var new_stars : Object = star_scene.instance()
		new_stars.set_global_position(Vector2(rand_range(-width, width), rand_range(-height, height)))
		stars_container.add_child(new_stars)

func _process(delta : float) -> void:
	for star_triad in self.get_children():
		star_triad.set_global_position(star_triad.get_global_position() + Vector2.UP * speed * delta)
		if star_triad.get_global_position().y < -extents.y:
			star_triad.global_position.y = extents.y
