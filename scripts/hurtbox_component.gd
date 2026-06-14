class_name HurtboxComponent extends Area2D

signal hit_received(hitbox: HitboxComponent)

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
	# emit signal to other components
	hit_received.emit(hitbox)
	
	# sprite animations
	if get_tree():
		animated_sprite.modulate = Color.RED
		await get_tree().create_timer(0.2).timeout
		animated_sprite.modulate = Color.WHITE
		
	
		
	
		
	
	
	
