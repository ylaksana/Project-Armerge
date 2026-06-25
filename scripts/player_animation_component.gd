class_name PlayerAnimationComponent extends Node

@export var hitbox: HitboxComponent
@export var body: CharacterBody2D
@export var animated_sprite: AnimatedSprite2D
@export var movement_component: MovementComponent
@export var combo_timer: Timer

var is_dead: bool = false
var is_attacking: bool = false
var is_aerial: bool = false
var combo_step: int = 0
var continue_combo: bool = false
var attack_animations = ["basicattack_1", "basicattack_2", "basicattack_3", "basicattack_4"]

# if an animation finishes, then a signal will be sent out to call _on_animation_finished
func _ready() -> void:
	animated_sprite.play("idle")
	animated_sprite.animation_finished.connect(_on_animation_finished)
	if not combo_timer.timeout.is_connected(_on_combo_timer_timeout):
		combo_timer.timeout.connect(_on_combo_timer_timeout)

# logic for how animations should behave after finishing
func _on_animation_finished() -> void:
	# stop animations and movement if dead
	if is_dead:
		return
	hitbox.curr_atk = null
	# combo window
	if animated_sprite.animation in attack_animations:
		if body.is_on_floor():
			#print("on ground")
			#print("animation: ",animated_sprite.animation)
			if is_aerial:
				if movement_component.dir != 0.0:
					#print("run after jump attack")
					animated_sprite.play("run")
				else:	
					animated_sprite.play("idle")
				_on_combo_timer_timeout()
			else:
				if animated_sprite.animation != attack_animations[-1]:
					combo_timer.start()
				else:
					_on_combo_timer_timeout()
				
				
		# if in the air, reset combo_step
		else:
			#print("in air")
			combo_step = 0
			hitbox.curr_atk = null
			is_attacking = false
			animated_sprite.play("jump")
	

			

# return whether the animated sprite playing doesn't have a loop
func non_loop_animation_playing() -> bool:
	return animated_sprite.is_playing() and not animated_sprite.sprite_frames.get_animation_loop(animated_sprite.animation)
		
		
func tick(delta: float) -> void:
	# disable movement if the character is freed or dead
	if body == null or is_dead:
		return
		
	if movement_component.wants_attack and animated_sprite.animation != attack_animations[-1]:
		continue_combo = true
	
	if is_aerial and is_attacking and body.is_on_floor():
		is_attacking = false
		is_aerial = false
		hitbox.curr_atk = null
		animated_sprite.play("run")
	
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
		if continue_combo:
			continue_combo = false
			attack()
			
		elif not combo_timer.is_stopped():
			if movement_component.dir != 0:
				combo_timer.stop()
				_on_combo_timer_timeout()
				animated_sprite.play("run")
		elif combo_timer.is_stopped():
			if movement_component.dir == 0.0:
				animated_sprite.play("idle") 
			else:
				animated_sprite.play("run")
	else:
		# jump_attack
		if continue_combo:
			continue_combo = false
			attack()
		elif not non_loop_animation_playing():
			animated_sprite.play("jump")

func attack() -> void:
	combo_timer.stop()
	is_attacking = true
	is_aerial = not body.is_on_floor() and is_attacking
	animated_sprite.play(attack_animations[combo_step])
	hitbox.set_curr_atk(animated_sprite.animation)
	if is_aerial:
		combo_step = 0
	else:
		movement_component.animation_based_movement(attack_animations[combo_step]) 
		combo_step = (combo_step + 1) % len(attack_animations)
	
func _on_combo_timer_timeout() -> void:
	#body.collision_mask = 3
	is_attacking = false
	hitbox.curr_atk = null
	#print("combo timeout!")
	combo_step = 0
	if body.is_on_floor():
		animated_sprite.play("idle")
