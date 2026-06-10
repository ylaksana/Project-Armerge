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
var prev_animation : String = ""

# if an animation finishes, then a signal will be sent out to call _on_animation_finished
func _ready() -> void:
	animated_sprite.play("idle")
	animated_sprite.animation_finished.connect(_on_animation_finished)

# logic for how animations should behave after finishing
func _on_animation_finished() -> void:
	# if the sprite is on the floor, we should just return to idle
	if body.is_on_floor():
		animated_sprite.play("idle")
		prev_animation = ""
		

# return whether the animated sprite playing doesn't have a loop
func non_loop_animation_playing() -> bool:
	return animated_sprite.is_playing() and not animated_sprite.sprite_frames.get_animation_loop(animated_sprite.animation)

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
		if non_loop_animation_playing():
			return
		if wants_attack:
			animated_sprite.play("attack")
		elif dir == 0.0:
			animated_sprite.play("idle") 
		else:
			animated_sprite.play("run")
	else:
		# jump_attack
		if wants_attack:
			animated_sprite.play("attack")
	
	
		
	# gravity:
	if not body.is_on_floor():
		body.velocity += body.get_gravity() * delta
	
	# jump:
	if wants_jump and body.is_on_floor():
		body.velocity.y = jump
		animated_sprite.play("jump")
	wants_jump = false
	
	body.move_and_slide()
	
	
	
