class_name MovementComponent extends Node

@export var body : Player
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

	if is_dead:
		return

	gravity(delta)
	movement()
	
func movement() -> void:
	# if body is on the floor
	if body.is_on_floor():
		# if an non-looping animation is playing
		if animation_component.non_loop_animation_playing():
			if body.hitbox_component.curr_atk and body.hitbox_component.curr_atk.movement_disabling:
				if not body.combo_component.is_aerial:
					body.velocity.x = 0
			else:
				body.velocity.x = dir * speed
		# if not, then if the player wants to move, they change the velocity
		elif dir != 0.0:
			body.velocity.x = dir * speed
		# if dir is 0.0, then they stop in place
		else:
			body.velocity.x = move_toward(body.velocity.x, 0, speed)

		# jump:
		if wants_jump and body.is_on_floor() and not body.combo_component.is_attacking:
			body.velocity.y = jump
	# if body is in the air
	else:
		if dir != 0.0:
			body.velocity.x = dir * speed
		else:
			body.velocity.x = move_toward(body.velocity.x, 0, speed)
			
func gravity(delta:float) -> void:
	# gravity:
	if not body.is_on_floor():
		body.velocity += body.get_gravity() * delta
	body.move_and_slide()

func animation_based_movement() -> void:
	if not body.is_on_floor():
		return
		
	var direction = 1 if animated_sprite.flip_h else -1
	var tween = create_tween()
	tween.tween_interval(body.hitbox_component.curr_atk.tween_delay)
	tween.tween_property(body, "velocity:x", speed * body.hitbox_component.curr_atk.lunge_speed * direction, 0.1).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
	tween.tween_property(body, "velocity:x", 0.0, 0.01).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN)
