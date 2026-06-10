class_name MovementComponent extends Node


@export var body : CharacterBody2D
@export var animated_sprite: AnimatedSprite2D
@export var model : Node2D
@export var speed: float = 150.0
@export var jump = 6.0
@export var gravity_multiplier = 3.0


var dir : float = 0.0
var wants_jump : bool = false
var wants_attack: bool = false

func tick(delta:float) -> void:
	# check if the character exists
	if body == null:
		return
		
	# body movement:
	if dir < 0.0:
		animated_sprite.flip_h = false
	elif dir > 0.0:
		animated_sprite.flip_h = true
	
	if dir != 0.0:
		body.velocity.x = dir * speed
	else:
		body.velocity.x = move_toward(body.velocity.x, 0, speed)
		
	# animations:
	
	if body.is_on_floor():
		if animated_sprite.animation == "attack" and animated_sprite.is_playing():
			pass
		elif dir == 0.0 and wants_attack:
			animated_sprite.play("attack")
		elif dir == 0.0:
			animated_sprite.play("idle")
		else:
			animated_sprite.play("run")
	else:
		animated_sprite.play("jump")
		
	
	
		
	# gravity:
	if not body.is_on_floor():
		body.velocity += body.get_gravity() * delta
	
	# jump:
	if wants_jump and body.is_on_floor():
		body.velocity.y = jump
	wants_jump = false
	
	body.move_and_slide()
	
	
	
