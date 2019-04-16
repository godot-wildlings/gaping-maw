extends Control
class_name UI

#onready var progress_bar : ProgressBar = $Panel/GridContainer/ProgressBar
#var progress_value : float

#warning-ignore:unused_signal
#signal progression

func _ready() -> void:
#	game.UI = self
#	progress_value = progress_bar.value
#	self.connect("progression", get_tree().get_root().get_node("/root/game"), "on_Object_Enter")
	pass

func _on_draggable_entered() -> void:
#	progress_value -= 10
	pass
