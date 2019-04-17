extends Node

onready var IntroScreen = $CanvasLayer/IntroScreen
onready var EndScreen = $CanvasLayer/EndScreen

var level_scenes = [
		"res://Scenes/Levels/Tutorial1.tscn",
		"res://Scenes/Levels/Tutorial2.tscn",
		"res://Scenes/Levels/Countdown.tscn",
		"res://Scenes/Levels/Level1.tscn"
	]
var level_idx : int = -1

func _init() -> void:
	game.main = self

func _ready() -> void:
	IntroScreen.show()

func next_level() -> void:
	if $AudioStreamPlayer.is_playing():
		$AudioStreamPlayer.stop()

	remove_previous_level()

	level_idx = wrapi(level_idx + 1, 0, level_scenes.size())
	var new_level_scene = load(level_scenes[level_idx])
	var new_level = new_level_scene.instance()

	$Levels.call_deferred("add_child", new_level)
	game.level = new_level

func remove_previous_level():

	if game.level != null and is_instance_valid(game.level):
		game.level.call_deferred("queue_free")

func remove_all_levels() -> void:
	for level in $Levels.get_children():
		if level.has_method("die"):
			level.die()
		else:
			level.call_deferred("queue_free")

func lose() -> void:
	remove_all_levels()
	EndScreen.show()
	$AudioStreamPlayer.play()

func restart() -> void:
	EndScreen.hide()
	IntroScreen.hide()
	next_level()
	$AudioStreamPlayer.stop()

