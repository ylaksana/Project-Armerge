class_name MovementComponent extends Node

@export var body : CharacterBody2D
@export var animated_sprite: AnimatedSprite2D
@export var hitbox: HitboxComponent
@export var collision_shape: CollisionShape2D
@export var model : Node2D
@export var speed: float = 150.0
@export var jump = 6.0
@export var gravity_multiplier = 3.0



var dir : float = 0.0
var wants_jump : bool = false
var wants_attack: bool = false
var hitbox_shape: CollisionShape2D
var hitbox_position: float
var hitbox_offset: float
var collision_position : float


# if an animation finishes, then a signal will be sent out to call _on_animation_finished
func _ready() -> void:
	# hitbox logic
	hitbox_shape = hitbox.get_node("CollisionShape2D")
	collision_position = collision_shape.position.x
	#print("hitbox_position before: ",hitbox_position)
	var collision_diameter = (collision_shape.shape as RectangleShape2D).size.x
	var hitbox_diameter = (hitbox_shape.shape as RectangleShape2D).size.x
	#print("hitbox_diameter: ",hitbox_diameter)
	#print("collision_diameter: ",collision_diameter)
	
	# set the offset for the hitbox
	hitbox_offset = (ceil(collision_diameter/2) + ceil(hitbox_diameter/2))
	#print(hitbox.get_parent().name)s
	# load the hitbox in front of where the player is facing
	if animated_sprite.flip_h == false:
		hitbox_position = collision_shape.position.x - hitbox_offset
	else:
		hitbox_position = collision_shape.position.x + hitbox_offset
		
	#print("hitbox_offset: ",hitbox_offset)
	#print("hitbox_position after: ", hitbox_position)
	
	animated_sprite.play("idle")
	animated_sprite.animation_finished.connect(_on_animation_finished)

# logic for how animations should behave after finishing
func _on_animation_finished() -> void:
	# turn off hitbox
	hitbox.monitoring = false
	# if the sprite is on the floor, we should just return to idle
	if body.is_on_floor():
		animated_sprite.play("idle")


# return whether the animated sprite playing doesn't have a loop
func non_loop_animation_playing() -> bool:
	return animated_sprite.is_playing() and not animated_sprite.sprite_frames.get_animation_loop(animated_sprite.animation)


func tick(delta:float) -> void:
	# check if the character exists
	if body == null:
		return
	
	# body movement:
	# move left
	if dir < 0.0:
		animated_sprite.flip_h = false
		# change the hitbox to face where the player is facing while hugging the overall collision shape
		hitbox_shape.position.x = collision_position - hitbox_offset
		print(hitbox_shape.position.x)
	
	# move right
	elif dir > 0.0:
		animated_sprite.flip_h = true
		# change the hitbox to face where the player is facing while hugging the overall collision shape
		hitbox_shape.position.x = collision_position + hitbox_offset
		print(hitbox_shape.position.x)
	
	
	if dir != 0.0:
		body.velocity.x = dir * speed
	else:
		body.velocity.x = move_toward(body.velocity.x, 0, speed)
		
	# animations:
	if body.is_on_floor():
		if non_loop_animation_playing():
			return
		if dir == 0.0:
			animated_sprite.play("idle") 
		else:
			animated_sprite.play("run")
			
		if wants_attack:
			animated_sprite.play("attack")
			hitbox.monitoring = true

	else:
		# jump_attack
		if wants_attack:
			animated_sprite.play("attack")
			hitbox.monitoring = true

	# gravity:
	if not body.is_on_floor():
		body.velocity += body.get_gravity() * delta
	
	# jump:
	if wants_jump and body.is_on_floor():
		body.velocity.y = jump
		animated_sprite.play("jump")
	wants_jump = false
	
	body.move_and_slide()
	
	
	
