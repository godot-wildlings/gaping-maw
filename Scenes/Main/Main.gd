extends Node

onready var Level1 = load("res://Scenes/Levels/Level1.tscn")

func _init():
	game.main = self
	
func _ready() -> void:
	next_level()

func next_level():
	var new_level = Level1.instance()
	$Levels.add_child(new_level)
	

func remove_levels():
	for level in $Levels.get_children():
		if level.has_method("die"):
			level.die()
		else:
			level.call_deferred("queue_free")

func lose():
	remove_levels()
	$EndScreen/CanvasLayer/PopupPanel.show()
	
func restart():
	$EndScreen/CanvasLayer/PopupPanel.hide()
	next_level()
