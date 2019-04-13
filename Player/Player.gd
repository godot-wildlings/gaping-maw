extends RigidBody2D


#FOLLOWED THIS FORUM POST - https://godotengine.org/qa/23651/newbie-how-to-get-a-key-press-event
#
#TRIED TO GET IT TO WORK

var status = "none"
var tileSize = Vector2()
var offset = Vector2()
var mousePos = Vector2()

onready var textureSprite = $Sprite

func _ready():
	tileSize = textureSprite.get_texture().get_size()
	set_process_input(true)
	set_process(true)

func _physics_process(delta):
	
	_is_clicked(global_position)
	
	if status == "clicked":
		global_position = mousePos + offset
	
func _input(event):
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_LEFT:
			if event.is_pressed() && _is_clicked(event.global_position):
				status = "clicked"
				mousePos = event.global_position
				offset = global_position - mousePos
				print("clicked")
			else:
				status = "released"
				print("released")
		elif event.type == InputEventMouseMotion:
			if status == "clicked":
				print("move")
				mousePos = get_viewport().get_mouse_position()

func _is_clicked(pos):
	var sprite_rect
	var gpos = global_position
	
	if textureSprite.is_centered():
		sprite_rect = Rect2(gpos.x - tileSize.x/2, gpos.y - tileSize.y/2, tileSize.x, tileSize.y)
	else:
		sprite_rect = Rect2(gpos.x, gpos.y, tileSize.x, tileSize.y)
	
	if sprite_rect.has_point(pos):
		return true
	return false


#THE BOTTOM OVER HERE IS JUNK CODE I DID TO TRY TO GET THE CODE TO WORK
#MAYBE LOOKING OVER HERE CAN HELP IN SOME WAY
# DOGGIEBALLOON
#
#	if Input.is_action_pressed("BUTTON_LEFT"):
#		if _is_clicked(global_position):
#			status = "clicked"
#			mousePos = global_position
#			offset = global_position - mousePos
#			print("clicked")
#		else:
#			status = "released"
#			print("released")
#	elif ev.type == InputEventMouseMotion.get_relative():
#		if status == "clicked":
#			print("move")
#			mousePos = get_viewport().get_mouse_position()

#func _input_event(something goes in here I think):
#
#	if ev.type == InputEvent.is_action_pressed:
#		if ev.button_index == BUTTON_LEFT:
#			if ev.is_pressed() && _is_clicked(ev.global_position):
#				status = "clicked"
#				mousePos = ev.global_pos
#				offset = global_position - mousePos
#				print("clicked")
#			else:
#				status = "released"
#				print("released")
#		elif ev.type == InputEvent.MOUSE_MOTION:
#			if status == "clicked":
#				print("move")
#				mousePos = get_viewport().get_mouse_position()