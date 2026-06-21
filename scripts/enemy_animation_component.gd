class_name EnemyAnimationComponent extends Node

@export var body: CharacterBody2D
@export var animated_sprite: AnimatedSprite2D
@export var hurtbox: HurtboxComponent
var hurt : bool = false

func _ready()->void:
	hurtbox.hit_received.connect(hit)
	
# return whether the animated sprite playing doesn't have a loop
func non_loop_animation_playing() -> bool:
	return animated_sprite.is_playing() and not animated_sprite.sprite_frames.get_animation_loop(animated_sprite.animation)

func hit(hitbox: HitboxComponent) -> void:
		hurt = true
		
func tick(delta: float):
	if body == null:
		return
	
	if body.is_on_floor():
		if non_loop_animation_playing():
			return
		if body.velocity.x == 0.0:
			animated_sprite.play("idle")
			
	if hurt:
		hurt = false
		animated_sprite.play("hurt")
