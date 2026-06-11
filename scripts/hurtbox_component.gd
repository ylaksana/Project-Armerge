class_name HurtboxComponent extends Area2D

signal hit_received(hitbox: HitboxComponent)

@export var is_invincible: bool = false
@export var body: CharacterBody2D
@export var animated_sprite : AnimatedSprite2D

func take_hit(hitbox: HitboxComponent) -> void:
	if is_invincible:
		return
		
	animated_sprite.modulate = Color.RED
	hit_received.emit(hitbox)
	
