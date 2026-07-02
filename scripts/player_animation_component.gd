class_name PlayerAnimationComponent extends Node

@export var body: Player
@export var animated_sprite: AnimatedSprite2D
@export var movement_component: MovementComponent

signal animation_finished

var body_shape: RectangleShape2D
var offset: float
var is_dead: bool = false
var wants_special_attack: bool = false

# if an animation finishes, then a signal will be sent out to call _on_animation_finished
func _ready() -> void:
	animated_sprite.play("idle")
	animated_sprite.animation_finished.connect(_on_animation_finished)
	offset = (body.get_node("CollisionShape2D").shape as RectangleShape2D).size.x / 2
	call_deferred("_connect_signals")

func _connect_signals() -> void:
	body.combo_component.attack_triggered.connect(_on_attack_triggered)
	
# logic for how animations should behave after finishing
func _on_animation_finished() -> void:
	# emit that animation finished
	animation_finished.emit()
	
# return whether the animated sprite playing doesn't have a loop
func non_loop_animation_playing() -> bool:
	return animated_sprite.is_playing() and not animated_sprite.sprite_frames.get_animation_loop(animated_sprite.animation)
		
func tick(delta: float) -> void:
	# disable animation if the character is freed or dead
	if body == null or is_dead:
		return
	print(body.combo_component.is_aerial)
	flip_hitbox()
	flip_animated_sprite()
	combo()

func combo() -> void:
	# if body is on floor
	if body.is_on_floor():
		if non_loop_animation_playing():
			return
		elif wants_special_attack:
			animated_sprite.play("fireball")
		elif not body.combo_component.combo_timer.is_stopped():
			if movement_component.dir != 0:
				animated_sprite.play("run")
		elif body.combo_component.combo_timer.is_stopped():
			if movement_component.dir == 0.0:
				animated_sprite.play("idle") 
			else:
				animated_sprite.play("run")
	# if body is in the air
	else:
		if not non_loop_animation_playing():
			animated_sprite.play("jump")
			
func _on_attack_triggered(animation_name:String) -> void:
	print("attack animation: ", animation_name)
	animated_sprite.play(animation_name)

func _on_combo_timer_timeout() -> void:
	if body.is_on_floor():
		animated_sprite.play("idle")
	
func flip_animated_sprite() -> void:
	if not body.combo_component.is_attacking:
		if movement_component.dir < 0.0:
			animated_sprite.flip_h = false
		
	# move right
		elif movement_component.dir > 0.0:
			animated_sprite.flip_h = true

func flip_hitbox() -> void:
	if not body.combo_component.is_attacking:
		body.pivot_component.flip_hitbox(animated_sprite.flip_h)
