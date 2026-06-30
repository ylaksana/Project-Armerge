class_name PivotComponent extends Node

@export var body_collision: CollisionShape2D
@export var hitbox_collision: CollisionShape2D

var hitbox_offset: float

func _ready() -> void:
	#print("hitbox_position before: ",hitbox_position)
	var collision_diameter = (body_collision.shape as RectangleShape2D).size.x
	var hitbox_diameter = (hitbox_collision.shape as RectangleShape2D).size.x
	#print("hitbox_diameter: ",hitbox_diameter)
	#print("collision_diameter: ",collision_diameter)
	
	# set the offset for the hitbox
	hitbox_offset = (ceil(collision_diameter/2) + ceil(hitbox_diameter/2))
	#print(hitbox.get_parent().name)
	# load the hitbox in front of where the player is facin
	
	#print("hitbox_offset: ",hitbox_offset)
	#print("hitbox_position after: ", hitbox_position)

func flip_hitbox(sprite_flipped: bool) -> void:
	if sprite_flipped:
		hitbox_collision.position.x = body_collision.position.x + hitbox_offset
	else:
		hitbox_collision.position.x = body_collision.position.x - hitbox_offset
