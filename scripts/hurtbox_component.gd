class_name HurtboxComponent extends Area2D

signal hit_received(hitbox: HitboxComponent)

@export var body: CharacterBody2D
@export var animated_sprite : AnimatedSprite2D

var on_cooldown: bool = false

#func _ready() -> void:
	#print("I am: ", get_parent().name, " hurtbox layer: ", collision_layer, " mask: ", collision_mask)

func take_hit(hitbox: HitboxComponent) -> void:
	# emit signal to other components
	hit_received.emit(hitbox)
	print("hit: ", body.name)
	print("hurtbox - hitbox.curr_atk: ", hitbox.curr_atk)
