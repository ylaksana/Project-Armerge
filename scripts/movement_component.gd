class_name MovementComponent extends Node

@export var body : CharacterBody2D
@export var animated_sprite: AnimatedSprite2D
@export var speed: float = 150.0
@export var jump = 6.0
@export var gravity_multiplier = 3.0

var dir : float = 0.0
var wants_jump : bool = false
var wants_attack: bool = false

func tick(delta:float) -> void:
	# gravity:
	if not body.is_on_floor():
		body.velocity += body.get_gravity() * delta
	body.move_and_slide()
	
	if body == null:
		return
	
	if dir != 0.0:
		body.velocity.x = dir * speed
	else:
		body.velocity.x = move_toward(body.velocity.x, 0, speed)
	
	# jump:
	if wants_jump and body.is_on_floor():
		body.velocity.y = jump
		
	wants_jump = false
	
