class_name MovementComponent extends Node

@export var body : CharacterBody2D
@export var animated_sprite: AnimatedSprite2D
@export var animation_component: PlayerAnimationComponent
@export var speed: float = 150.0
@export var jump = 6.0
@export var gravity_multiplier = 3.0

var dir : float = 0.0
var wants_jump : bool = false
var wants_attack: bool = false
var is_dead: bool = false


func tick(delta:float) -> void:
	if body == null:
		return	
		
	# gravity:
	if not body.is_on_floor():
		body.velocity += body.get_gravity() * delta
	body.move_and_slide()
	
	if is_dead:
		return
	
	if (animation_component.non_loop_animation_playing() or not animation_component.combo_timer.is_stopped()) and not animation_component.is_aerial:
		body.velocity.x = 0
	elif dir != 0.0:
		body.velocity.x = dir * speed
	else:
		body.velocity.x = move_toward(body.velocity.x, 0, speed)
	
	# jump:
	if wants_jump and body.is_on_floor() and not animation_component.is_attacking:
		body.velocity.y = jump
	wants_jump = false
	
func animation_based_movement(animation: String) -> void:
	var direction = 1 if animation_component.animated_sprite.flip_h else -1
	var tween = create_tween()
	#print("current animation: ", animation)
	if animation == "basicattack_3":
		tween.tween_interval(0.2)
		tween.tween_property(body, "velocity:x", speed * 2 * direction, 0.1).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
		tween.tween_property(body, "velocity:x", 0.0, 0.01).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN)
	elif animation == "basicattack_4":
		tween.tween_interval(0.2)
		tween.tween_property(body, "velocity:x", speed * 3 * direction, 0.1).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
		tween.tween_property(body, "velocity:x", 0.0, 0.01).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN)
	else:
		tween.tween_property(body, "velocity:x", speed * 0.3 * direction, 0.1).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
		tween.tween_property(body, "velocity:x", 0.0, 0.1).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN)
	
	
	
	
	
