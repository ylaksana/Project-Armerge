class_name HurtboxComponent extends Area2D

signal hit_received(hitbox: HitboxComponent)

@export var body: CharacterBody2D
@export var animated_sprite : AnimatedSprite2D

func take_hit(hitbox: HitboxComponent) -> void:
	print("I am: ", get_parent().name, " hurtbox layer: ", collision_layer, " mask: ", collision_mask)
	animated_sprite.modulate = Color.RED
	hit_received.emit(hitbox)
	await get_tree().create_timer(0.2).timeout
	animated_sprite.modulate = Color.WHITE
	
