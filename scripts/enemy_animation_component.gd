class_name EnemyAnimationComponent extends Node

@export var body: Enemy
@export var animated_sprite: AnimatedSprite2D
@export var hurtbox: HurtboxComponent
var hurt : bool = false
var is_hit: bool = false

func _ready() -> void:
	hurtbox.hit_received.connect(hit)
	
#func _on_animation_finished() -> void:
	#if animated_sprite.animation == "attack":
		#body.enemy_movement_component.attack_finished()
	#
# return whether the animated sprite playing doesn't have a loop
func non_loop_animation_playing() -> bool:
	return animated_sprite.is_playing() and not animated_sprite.sprite_frames.get_animation_loop(animated_sprite.animation)

func hit(hitbox: HitboxComponent) -> void:
		hurt = true
		
func tick(delta: float):
	if body == null:
		return
		
	if hurt:
		hurt = false
		animated_sprite.play("hurt")
		body.animated_components.play("hit_flash")
		return
		
	if body.is_on_floor():
		if non_loop_animation_playing():
			return
		if body.enemy_movement_component.curr_state == body.enemy_movement_component.State.ATTACK:
			animated_sprite.play("attack")
			body.animated_components.play("attack")
			body.hitbox_component.scale.x = -1.0 if animated_sprite.flip_h else 1.0
		elif body.enemy_movement_component.curr_state == EnemyMovementComponent.State.CHASE or body.enemy_movement_component.prev_state == EnemyMovementComponent.State.CHASE:
			animated_sprite.play("aggressive")
		else:
			animated_sprite.play("idle")
				
