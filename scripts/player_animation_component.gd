class_name PlayerAnimationComponent extends Node

@export var hitbox: HitboxComponent
@export var body: CharacterBody2D
@export var animated_sprite: AnimatedSprite2D
@export var movement_component: MovementComponent
@export var combo_timer: Timer

var is_jump_attack: bool = false
var is_dead: bool = false
var is_attacking: bool = false
var combo_step: int = 0
var attack_animations = ["basicattack_1", "basicattack_2"]

# if an animation finishes, then a signal will be sent out to call _on_animation_finished
func _ready() -> void:
	animated_sprite.play("idle")
	animated_sprite.animation_finished.connect(_on_animation_finished)
	combo_timer.timeout.connect(_on_combo_timer_timeout)

# logic for how animations should behave after finishing
func _on_animation_finished() -> void:
	# stop animations and movement if dead
	if is_dead:
		return
	# we're not attacking anymore
	hitbox.monitoring = false
	
	# combo window
	if animated_sprite.animation in attack_animations:
		if body.is_on_floor():
			combo_timer.start()
		else:
			is_attacking = false
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
	if not is_attacking:
		if movement_component.dir < 0.0:
			animated_sprite.flip_h = false
		
		# move right
		elif movement_component.dir > 0.0:
			animated_sprite.flip_h = true
			
	
	if body.is_on_floor():
		if non_loop_animation_playing():
			return
		if movement_component.wants_attack:
			attack()
			
		elif combo_timer.is_stopped():
			if movement_component.dir == 0.0:
				animated_sprite.play("idle") 
			else:
				animated_sprite.play("run")
	else:
		# jump_attack
		if movement_component.wants_attack:
			is_attacking = true
			animated_sprite.play("basicattack_1")
		elif not non_loop_animation_playing():
			animated_sprite.play("jump")


func attack() -> void:
	combo_timer.stop()
	hitbox.monitoring = true
	is_attacking = true
	animated_sprite.play(attack_animations[combo_step])
	combo_step = (combo_step + 1) % len(attack_animations)
	
func _on_combo_timer_timeout() -> void:
	is_attacking = false
	print("combo timeout!")
	# if the sprite has , we should just return to idle
	if body.is_on_floor():
		animated_sprite.play("idle")
