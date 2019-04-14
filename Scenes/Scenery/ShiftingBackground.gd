extends Sprite

# Declare member variables here. Examples:
var base_rect : Rect2
var texture_shift_y : float
export var speed_factor : float = 25.0

# Called when the node enters the scene tree for the first time.
func _ready():
	base_rect = get_region_rect()
	texture_shift_y = 0

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	texture_shift_y += 1 * speed_factor * delta
	texture_shift_y = wrapf(texture_shift_y, 0, base_rect.size.y)
	
	var new_rect = base_rect
	new_rect.position.y = texture_shift_y
	
	set_region_rect(new_rect)
