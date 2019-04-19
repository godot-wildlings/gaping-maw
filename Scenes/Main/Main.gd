extends Node

onready var IntroScreen : PopupPanel = $CanvasLayer/IntroScreen
onready var EndScreen : PopupPanel = $CanvasLayer/EndScreen
onready var QuitScreen : PopupPanel = $CanvasLayer/QuitScreen

var level_idx : int = -1
var level_scenes = [
		"res://Scenes/Levels/Tutorial1.tscn",
		"res://Scenes/Levels/Tutorial2.tscn",
		"res://Scenes/Levels/Countdown.tscn",
		"res://Scenes/Levels/Level1.tscn"
	]

func _init() -> void:
	game.main = self

func _ready() -> void:
	IntroScreen.show()
	QuitScreen.hide()

func next_level() -> void:
	level_idx = wrapi(level_idx + 1, 0, level_scenes.size())
	goto_level(level_idx)

func goto_level(level_num : int) -> void:
	game.reset_scores()

	if $AudioStreamPlayer.is_playing():
		$AudioStreamPlayer.stop()

	remove_previous_level()

	var new_level_scene : PackedScene = load(level_scenes[level_num])
	var new_level : Object = new_level_scene.instance()

	$Levels.call_deferred("add_child", new_level)
	game.level = new_level
	level_idx = level_num

func remove_previous_level() -> void:
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

	if game.score["Time_Elapsed"] > game.score["Best_Time"]:
		game.score["Best_Time"] = game.score["Time_Elapsed"]

	var textbox = $CanvasLayer/EndScreen/MarginContainer/VBoxContainer/CenterContainer/WinLoseText

	var score_container = $CanvasLayer/EndScreen/MarginContainer/VBoxContainer/Score
	score_container.get_node("Planets/PlanetsLost").set_text(str(game.score["Planets_Lost"]))
	score_container.get_node("Creatures/CreaturesDestroyed").set_text(str(game.score["Creatures_Destroyed"]))
	score_container.get_node("Time/TimeElapsed").set_text(str(floor(game.score["Time_Elapsed"]*100)/100))

	var highscore_container = $CanvasLayer/EndScreen/MarginContainer/VBoxContainer/HighScore
	highscore_container.get_node("Time/TimeElapsed").set_text(str(floor(game.score["Best_Time"]*100)/100))
	if cause_of_death != "":
		textbox.set_text("Death by " + cause_of_death)
	EndScreen.show()
	$AudioStreamPlayer.play()

func quit_game() -> void:
	QuitScreen.show()
	#options_panel.hide()
	
	# for the html version
	get_tree().paused = true
	QuitScreen.get_node("QuitTimer").start()

func restart() -> void:
	if get_tree().paused == true:
		get_tree().paused = false
	
	$AudioStreamPlayer.stop()
	EndScreen.hide()
	IntroScreen.hide()
	level_idx = -1
	next_level()

func skip_tutorial() -> void:
	goto_level(2)

func _on_QuitTimer_timeout() -> void:
	get_tree().quit()