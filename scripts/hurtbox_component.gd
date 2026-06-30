class_name HurtboxComponent extends Area2D

signal hit_received(hitbox: HitboxComponent)

@export var body: CharacterBody2D
@export var animated_sprite : AnimatedSprite2D
@export var is_player: bool = true


func take_hit(hitbox: HitboxComponent) -> void:
	# emit signal to other components
	hit_received.emit(hitbox)
	print("hit: ", body.name)
