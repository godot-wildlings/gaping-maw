extends Node

var game_ui : PackedScene = preload("res://Scenes/UI/UI.tscn") as PackedScene

func _ready() -> void:
	var add_game_ui = game_ui.instance()
	add_child(add_game_ui)