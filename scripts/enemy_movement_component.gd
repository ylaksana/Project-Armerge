class_name EnemyMovementComponent extends Node

@export var body: CharacterBody2D
@export var animated_sprite: AnimatedSprite2D
@export var enemy_animation_component: EnemyAnimationComponent
@export var hurtbox: HurtboxComponent
@export var speed: float = 150.0
@export var jump = 6.0
@export var gravity_multiplier = 3.0
@export var hit_vfx: PackedScene

func _ready() -> void:
	hurtbox.hit_received.connect(_on_hit_received)

func tick(delta: float):
	if body == null:
		return

	if not body.is_on_floor():
		body.velocity += body.get_gravity() * delta
	body.move_and_slide()


func _on_hit_received(hitbox: HitboxComponent, right_hit: bool) -> void:
		#print("hurt")
		if hit_vfx:
			var position = hurtbox.global_position
			var vfx = hit_vfx.instantiate()
			get_tree().root.add_child(vfx)
			vfx.global_position = position
			
		var direction = -1 if right_hit else 1
		var tween = create_tween()
		if hitbox.curr_atk.animation_name == "basicattack_4":
			tween.tween_property(body, "velocity:x", speed * 2 * direction, 0.1).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
			tween.parallel().tween_property(body, "velocity:y", -speed * 0.5, 0.01).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
			tween.tween_property(body, "velocity:x", 0.0, 0.05).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN)
		else:
			tween.tween_property(body, "velocity:x", speed * direction, 0.05).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
			tween.tween_property(body, "velocity:x", 0.0, 0.01).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN)
		
		
		
		
