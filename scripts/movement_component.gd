class_name MovementComponent extends Node

@export var body: Player
@export var animated_sprite: AnimatedSprite2D
@export var speed: float = 150.0
@export var jump = 6.0
@export var gravity_multiplier = 0.0

var dir : float = 0.0
var wants_jump : bool = false
var wants_attack: bool = false
var is_dead: bool = false

func tick(delta:float) -> void:
	if body == null:
		return	

	if is_dead:
		return
	#print(body.velocity.x)
	gravity(delta)
	movement()
	
func movement() -> void:
	# if body is on the floor
	if body.is_on_floor():
		if body.combo_component.is_attacking:
			if body.player_animation_component.non_loop_animation_playing():
				body.velocity.x = move_toward(body.velocity.x, 0, speed)
		elif wants_jump:
			body.velocity.y = jump
		elif dir != 0.0:
			body.velocity.x = dir * speed
		else:
			body.velocity.x = move_toward(body.velocity.x, 0, speed)
	# if body is in the air
	else:
		body.velocity.x = dir * speed
			
func gravity(delta:float) -> void:
	# gravity:
	if not body.is_on_floor():
		body.velocity += body.get_gravity() * delta
	body.move_and_slide()

func animation_based_movement() -> void:
	print("using lunge speed from curr_atk: ", body.hitbox_component.curr_atk)
	print("lunge speed: ", body.hitbox_component.curr_atk.lunge_speed)
	if not body.is_on_floor():
		return
	if body.hitbox_component.curr_atk.lunge_speed == 0.0:
		return
	var direction = 1 if animated_sprite.flip_h else -1
	var tween = create_tween()
	tween.tween_interval(body.hitbox_component.curr_atk.tween_delay)
	tween.tween_property(body, "velocity:x", speed * body.hitbox_component.curr_atk.lunge_speed * direction, 0.1).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
	tween.tween_property(body, "velocity:x", 0.0, 0.01).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN)
