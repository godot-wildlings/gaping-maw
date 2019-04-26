extends Node

#warning-ignore:unused_class_variable
var black_hole : BlackHole
#warning-ignore:unused_class_variable
var UI : UI
#warning-ignore:unused_class_variable
var player : RigidBody2D
#warning-ignore:unused_class_variable
var cursor : Area2D
#warning-ignore:unused_class_variable
var main : Node
#warning-ignore:unused_class_variable
var level : Node2D
#warning-ignore:unused_class_variable
var debug : bool = true

#warning-ignore:unused_class_variable
var options : Dictionary = {
	"Creatures_Grabbable" : true,
	"Creatures_Walk_The_Line" : false,
	"Endless_Oxygen" : false,
	"Indestructable_Suit" : false,
	#"mouse_drag_speed" : 6.0,
	#"autograb" : true
	"Level_Duration" : 220
}

#warning-ignore:unused_class_variable
var score : Dictionary = {
	"Creatures_Destroyed" : 0,
	"Planets_Lost": 0,
	"Time_Elapsed": 0,
	"Best_Time": 0
}

func reset_scores():
	score["Creatures_Destroyed"] = 0
	score["Planets_Lost"] = 0
	score["Time_Elapsed"] = 0

	black_hole = null
#	player = null
#	cursor = null
#	level = null

#Moved to main.tscn, because it needs GUI elements
#func quit_game():
#	get_tree().quit()