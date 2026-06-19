class_name PlayerAnimationComponent extends Node

@export var hitbox: HitboxComponent
@export var body: CharacterBody2D
@export var animated_sprite: AnimatedSprite2D
@export var movement_component: MovementComponent
@export var combo_timer: Timer

var is_jump_attack: bool = false
var is_dead: bool = false
var is_attacking: bool = false
var is_aerial: bool = false
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
		# start timer if on floor
		if body.is_on_floor():
			print("on ground")
			if animated_sprite.animation != attack_animations[-1]:
				combo_timer.start()
			else:
				if animated_sprite.animation == "basicattack_1" and movement_component.dir != 0.0:
					animated_sprite.play("run")
				else:	
					animated_sprite.play("idle")
				is_attacking = false
				combo_step = 0
				
		# if in the air, reset combo_step
		else:
			print("in air")
			combo_step = 0
			is_attacking = false
			animated_sprite.play("idle")
	
	is_aerial = false
			

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
			attack()
		elif not non_loop_animation_playing():
			animated_sprite.play("jump")


func attack() -> void:
	combo_timer.stop()
	hitbox.monitoring = true
	is_attacking = true
	is_aerial = not body.is_on_floor()
	animated_sprite.play(attack_animations[combo_step])
	if is_aerial:
		combo_step = 0
	else:
		combo_step = (combo_step + 1) % len(attack_animations)
	
func _on_combo_timer_timeout() -> void:
	is_attacking = false
	print("combo timeout!")
	combo_step = 0
	if body.is_on_floor():
		animated_sprite.play("idle")
