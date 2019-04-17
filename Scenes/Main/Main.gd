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

func lose(cause_of_death : String = "") -> void:
	remove_all_levels()

	var textbox = $CanvasLayer/EndScreen/MarginContainer/VBoxContainer/CenterContainer/WinLoseText

	var score_container = $CanvasLayer/EndScreen/MarginContainer/VBoxContainer/Score
	score_container.get_node("Planets/PlanetsLost").set_text(str(game.score["Planets_Lost"]))
	score_container.get_node("Creatures/CreaturesDestroyed").set_text(str(game.score["Creatures_Destroyed"]))
	score_container.get_node("Time/TimeElapsed").set_text(str(floor(game.score["Time_Elapsed"]*100)/100))

	if cause_of_death != "":
		textbox.set_text("Death by " + cause_of_death)
	EndScreen.show()
	$AudioStreamPlayer.play()

func restart() -> void:
	if get_tree().paused == true:
		get_tree().paused = false
	$AudioStreamPlayer.stop()
	EndScreen.hide()
	IntroScreen.hide()
	level_idx = -1
	next_level()


