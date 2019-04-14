extends Control
class_name UI

onready var progress_bar : ProgressBar = $ProgressBar
var progress_value : int

signal progression

func _ready() -> void:
	game.UI = self
	progress_value = progress_bar.value
#	self.connect("progression", get_tree().get_root().get_node("/root/game"), "on_Object_Enter")

func on_draggable_entered() -> void:
	progress_value -= 10
