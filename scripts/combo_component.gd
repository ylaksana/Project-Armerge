class_name ComboComponent extends Node

@export var body: Player
@export var combo_timer: Timer
@export var animation_component: PlayerAnimationComponent

signal attack_triggered(animation_name:String)

var is_attacking: bool = false
var is_aerial: bool = false
var combo_step: int = 0
var continue_combo: bool = false
var wants_special_attack: bool = false
var attack_animations: Array[String] = ["basicattack_1", "basicattack_2", "basicattack_3", "basicattack_4"]
var aerial_attack_animations: Array[String] = ["aerialattack_1","aerialattack_2","aerialattack_3","aerialattack_4"]
func _ready() -> void:
	if not combo_timer.timeout.is_connected(_on_combo_timer_timeout):
		combo_timer.timeout.connect(_on_combo_timer_timeout)
	animation_component.animation_finished.connect(_on_animation_finished)

func tick(delta: float) -> void:
	if body == null:
		return
		
	combo() 

# return whether the animated sprite playing doesn't have a loop
func non_loop_animation_playing() -> bool:
	return body.animated_sprite.is_playing() and not body.animated_sprite.sprite_frames.get_animation_loop(body.animated_sprite.animation)

func combo() -> void:
	# combo buffer
	if body.movement_component.wants_attack and body.animated_sprite.animation != attack_animations[-1]:
		continue_combo = true
		
	# landing from an aerial attack
	if is_aerial and body.is_on_floor():
		is_aerial = false
		_on_combo_timer_timeout()
		
	# if body is on floor
	if body.is_on_floor():
		if non_loop_animation_playing():
			return
		# special attack
		elif wants_special_attack:
			attack()
		elif continue_combo:
			continue_combo = false
			attack()
		elif not combo_timer.is_stopped():
			if body.movement_component.dir != 0:
				combo_timer.stop()
				_on_combo_timer_timeout()
				
	# if body is in the air
	else:
		# jump_attack
		if continue_combo:
			continue_combo = false
			attack()
			
func attack() -> void:
	combo_timer.stop()
	is_attacking = true
	is_aerial = not body.is_on_floor() and is_attacking
	if not wants_special_attack:
		body.attack_component.set_curr_atk(attack_animations[combo_step])
		attack_triggered.emit(attack_animations[combo_step])
		if is_aerial:
			combo_step = 0
		else:
			combo_step = (combo_step + 1) % len(attack_animations)
	else:
		body.attack_component.set_curr_atk("fireball")
		attack_triggered.emit("fireball")
	body.movement_component.animation_based_movement()

func _on_animation_finished() -> void:
	# combo window
	print("animation_finished - is_attacking: ", is_attacking)
	print("animation_finished - wants_special_attack: ", wants_special_attack)
	if body.hitbox_component.curr_atk:
		if (body.animated_sprite.animation in attack_animations) or body.hitbox_component.curr_atk.is_special_attack:
			if body.is_on_floor():
				if is_aerial:
					is_aerial = false
					_on_combo_timer_timeout()
				else:
					# continue if attack is valid in combo
					if (body.animated_sprite.animation != attack_animations[-1]) or body.hitbox_component.curr_atk.is_special_attack:
						print("combo timer start!")
						combo_timer.start()
					# end if end of the combo
					else:
						_on_combo_timer_timeout()
		
			# if in the air, reset combo_step
			else:
				combo_step = 0
				body.hitbox_component.curr_atk = null
				is_attacking = false
		else:
			is_attacking = false

func _on_combo_timer_timeout() -> void:
	is_attacking = false
	if wants_special_attack:
		wants_special_attack = false
	body.hitbox_component.monitoring = false
	body.hitbox_component.curr_atk = null
	combo_step = 0
