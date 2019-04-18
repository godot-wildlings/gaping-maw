extends Area2D
class_name BlackHole

onready var EventHorizon = $EventHorizon
export var base_speed : float = 20.0
export var time_to_double_speed : float = 45

var gravity_radius : float
var speed : float = base_speed
var time_elapsed : float

signal draggable_entered

func _init() -> void:
	game.black_hole = self

func _ready() -> void:
	gravity_radius = $GravityRadius.shape.radius
	call_deferred("deferred_ready")

func deferred_ready() -> void:
	#warning-ignore:return_value_discarded
	EventHorizon.connect("body_entered", self, "_on_EventHorizon_body_entered")
	#warning-ignore:return_value_discarded
	#self.connect("draggable_entered", game.UI, "_on_draggable_entered")

func move_toward_player(delta) -> void:
	var my_pos = get_global_position()
	var player_pos = game.player.get_global_position()
	var dist_sq_to_player = (player_pos - my_pos).length_squared()

	# move faster if you're far away from player
	var radius_increment : float  = 750.0
	var time_factor : float = 1.0 + time_elapsed / time_to_double_speed
	speed = base_speed * dist_sq_to_player / (radius_increment * radius_increment) * time_factor

	var vector_to_player = (player_pos - my_pos).normalized() * speed
	position += vector_to_player * delta

func _process(delta : float) -> void:
	time_elapsed += delta

	move_toward_player(delta)

func _on_EventHorizon_body_entered(body : PhysicsBody2D) -> void:
	# we could do some progress stuff here if we like.
		# if the black hole is supposed to be destroyable.
	if body == game.player:
		body.die("instantaneous, infinite and unfathomable compression inside a black hole.")

#	elif body.is_in_group("draggable"):
#		emit_signal("draggable_entered") # in case we want to destroy the black hole by throwing cows into it


	if body.has_method("die"):
		body.die()
	else:
		body.call_deferred("queue_free")

func spawn_creature() -> void:
	var creature_scene : PackedScene = load("res://Scenes/Creatures/Creature.tscn")
	var new_creature : Object = creature_scene.instance()
	$Creatures.add_child(new_creature)
	new_creature.set_global_position(get_global_position())

func _on_CreatureSpawnTimer_timeout() -> void:
	spawn_creature()
