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
	
	if (animation_component.non_loop_animation_playing() or not animation_component.combo_timer.is_stopped()) and body.is_on_floor():
		body.velocity.x = 0
	elif dir != 0.0:
		body.velocity.x = dir * speed
	else:
		body.velocity.x = move_toward(body.velocity.x, 0, speed)
	
	# jump:
	if wants_jump and body.is_on_floor():
		body.velocity.y = jump
	wants_jump = false
	
	
	
	
	
