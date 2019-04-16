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
var planets_destroyed : int = 0
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
	"Creatures_Autograb_Hook" : false
}