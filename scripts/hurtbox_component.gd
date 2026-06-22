class_name HurtboxComponent extends Area2D

signal hit_received(hitbox: HitboxComponent, right_hit: bool)

@export var body: CharacterBody2D
@export var animated_sprite : AnimatedSprite2D
@export var is_player: bool = true

func _ready() -> void:
	if is_player:
		collision_layer = 2
		collision_mask = 4
	else:
		collision_layer = 8
		collision_mask = 1

func take_hit(hitbox: HitboxComponent) -> void:
	var right_hit = hitbox.global_position.x > global_position.x
	# emit signal to other components
	hit_received.emit(hitbox, right_hit)
	print("hit: ", body.name)

	
		
	
		
	
	
	
