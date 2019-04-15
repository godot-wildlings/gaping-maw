extends Node

onready var level_1 : PackedScene = load("res://Scenes/Levels/Level1.tscn")
onready var IntroScreen = $CanvasLayer/IntroScreen
onready var EndScreen = $CanvasLayer/EndScreen

func _init() -> void:
	game.main = self

func _ready() -> void:
	IntroScreen.show()

func next_level() -> void:
	var new_level = level_1.instance()
	$Levels.add_child(new_level)


func remove_levels() -> void:
	for level in $Levels.get_children():
		if level.has_method("die"):
			level.die()
		else:
			level.call_deferred("queue_free")

func lose() -> void:
	remove_levels()
	EndScreen.show()

func restart() -> void:
	EndScreen.hide()
	IntroScreen.hide()
	next_level()
