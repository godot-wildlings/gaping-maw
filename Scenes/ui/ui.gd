extends Control

var progressValue : int

onready var progressBar = $ProgressBar

signal progression

func _ready():
	
	progressValue = progressBar.value
	
#	self.connect("progression", get_tree().get_root().get_node("/root/game"), "on_Object_Enter")

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func on_draggable_entered():
	
	progressValue -= 10