extends Path2D

var my_curve : Curve2D
#var creature_hooked : bool = false
export var crawl_speed : float = 0.25

onready var line_offset_setter = $PathFollow2D
onready var line_offset_getter = $PathFollow2D/Position2D


func _ready():
	set_as_toplevel(true)
	initialize_curve()


func initialize_curve():
	my_curve = Curve2D.new()
	my_curve.add_point(game.cursor.get_global_position())
	my_curve.add_point(game.player.get_global_position(), Vector2.ZERO, Vector2.ZERO)
	line_offset_setter.unit_offset = 0.0
	set_curve(my_curve)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	# update the two points on the curve to match player position and cursor position
	update_endpoints()
	move_offset(delta)

	update()


func update_endpoints():
	my_curve.set_point_position(0, game.cursor.get_global_position())
	my_curve.set_point_position(1, game.player.get_global_position())

func get_target_position():
	return line_offset_getter.get_global_position()


func move_offset(delta):

	var old_offset = line_offset_setter.get_unit_offset()
	var new_offset = old_offset + crawl_speed * delta
	new_offset = clamp(new_offset, 0.0, 1.0)
	line_offset_setter.unit_offset = new_offset



func _draw():
	draw_line(my_curve.get_point_position(0), my_curve.get_point_position(1), Color.aquamarine, 8, true)
