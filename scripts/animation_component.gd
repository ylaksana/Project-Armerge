class_name AnimationComponent extends Node

@export var hitbox: HitboxComponent
@export var body: CharacterBody2D
@export var animated_sprite: AnimatedSprite2D
@export var movement_component: MovementComponent
@export var is_player: bool = true

var is_dead: bool = false

# if an animation finishes, then a signal will be sent out to call _on_animation_finished
func _ready() -> void:
	animated_sprite.play("idle")
	animated_sprite.animation_finished.connect(_on_animation_finished)

# logic for how animations should behave after finishing
func _on_animation_finished() -> void:
	# stop animations and movement if dead
	if is_dead:
		return
	# turn off hitbox
	hitbox.monitoring = false
	# if the sprite is on the floor, we should just return to idle
	if body.is_on_floor():
		animated_sprite.play("idle")

# return whether the animated sprite playing doesn't have a loop
func non_loop_animation_playing() -> bool:
	return animated_sprite.is_playing() and not animated_sprite.sprite_frames.get_animation_loop(animated_sprite.animation)

	
func tick(delta: float) -> void:
	# disable movement if the character is freed or dead
	if body == null or is_dead:
		return
	
	# body movement:
		# move left
	if movement_component.dir < 0.0:
		animated_sprite.flip_h = false
	
	# move right
	elif movement_component.dir > 0.0:
		animated_sprite.flip_h = true
			
	
	if body.is_on_floor():
		if non_loop_animation_playing():
			return
		if movement_component.dir == 0.0:
			animated_sprite.play("idle") 
		else:
			animated_sprite.play("run")
			
		if movement_component.wants_attack:
			animated_sprite.play("basicattack_1")
			hitbox.monitoring = true

	else:
		# jump_attack
		if movement_component.wants_attack:
			animated_sprite.play("attack")
			hitbox.monitoring = true
		elif not non_loop_animation_playing():
			animated_sprite.play("jump")
	
