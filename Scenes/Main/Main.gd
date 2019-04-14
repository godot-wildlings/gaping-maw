extends Node

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var game_ui = preload("res://Scenes/ui/ui.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	
	var add_game_ui = game_ui.instance()
	
	add_child(add_game_ui)

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
