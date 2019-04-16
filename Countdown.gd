extends Node2D

var timer_ticks_remaining : int = 3

# Called when the node enters the scene tree for the first time.
func _ready():
	update_label()

func update_label():
	$CanvasLayer/CenterContainer/Label.set_text(str(timer_ticks_remaining))




func _on_Timer_timeout():
	timer_ticks_remaining -= 1
	update_label()

	if timer_ticks_remaining == 0:
		game.main.next_level()
