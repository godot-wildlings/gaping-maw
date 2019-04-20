extends Camera2D

#warning-ignore:unused_class_variable
var target = null
var desired_zoom : Vector2 = Vector2(6, 6)
var ticks : int = 0
var min_zoom : float = 0.3
var max_zoom : float = 8.0

func _ready() -> void:
	desired_zoom = zoom

func _process(delta : float) -> void:
	ticks += 1
	zoom = lerp(zoom, desired_zoom, 0.2 * delta * 60)


func _input(event : InputEvent):
	if event is InputEventMouseButton and event.is_action("zoom_in"):
		desired_zoom = zoom * 0.8
	if event is InputEventMouseButton and event.is_action("zoom_out"):
		desired_zoom = zoom * 1.25

	desired_zoom.x = clamp(desired_zoom.x, min_zoom, max_zoom)
	desired_zoom.y = clamp(desired_zoom.y, min_zoom, max_zoom)