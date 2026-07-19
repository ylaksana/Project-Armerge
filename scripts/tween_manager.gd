class_name TweenManager extends Node

signal knockback_finished
signal enemy_attack_finished

# hyperparams
@export var light_knockback_min: float = 0.5
@export var light_knockback_max: float = 1.6
@export var medium_knockback_min: float = 1.7
@export var medium_knockback_max: float = 2.5
@export var heavy_knockback_min: float = 2.8
@export var heavy_knockback_max: float = 3.5
@export var knockback_speed_x: float = 150.0
@export var knockback_speed_y: float = 25.0



var knockback_tween: Tween = null
var attack_tween: Tween = null
var rng = RandomNumberGenerator.new()
var knockback_direction: float
var attack_direction: float
var knockback_stun_duration: float = 0.5

func _ready() -> void:
	rng.randomize()

func knockback_motion(body: CharacterBody2D, hitbox: HitboxComponent):
	var attack: AttackData
	if hitbox.curr_atk:
		attack = hitbox.curr_atk
	else:
		attack = hitbox.passive_attack
		
	knockback_direction = -1 if hitbox.right_hit else 1
	
	if knockback_tween:
		knockback_tween.kill()
	knockback_tween = create_tween()

	print("attack_weight: ", attack.attack_weight)
	
	if attack.attack_weight == "light":
		light_knockback(body)
	elif attack.attack_weight == "medium":
		medium_knockback(body)
	elif attack.attack_weight == "heavy":
		heavy_knockback(body)
	else:
		print("Unknown attack weight: ", attack.attack_weight)
	
	knockback_tween.tween_interval(knockback_stun_duration)
	knockback_tween.finished.connect(_on_knockback_motion_finished)

func enemy_attack_motion(body: CharacterBody2D):
	attack_direction = 1 if body.animated_sprite.flip_h else -1
	if attack_tween:
		attack_tween.kill()
	attack_tween = create_tween()
	attack_tween.tween_interval(0.3)
	attack_tween.tween_property(body, "velocity:x", 100 * attack_direction, 0.5).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
	attack_tween.tween_property(body, "velocity:x", 0.0, 0.1).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN)
	attack_tween.finished.connect(_on_enemy_attack_finished)
	
func light_knockback(body:CharacterBody2D) -> void:
	print("light attack tween")
	var random_multiplier = rng.randf_range(light_knockback_min,light_knockback_max)
	knockback_tween.tween_property(body, "velocity:x", knockback_speed_x * random_multiplier * knockback_direction, 0.05).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
	knockback_tween.tween_property(body, "velocity:x", 0.0, 0.01).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN)
	
func medium_knockback(body:CharacterBody2D) -> void:
	print("medium attack tween")
	var random_multiplier = rng.randf_range(medium_knockback_min, medium_knockback_max)
	knockback_tween.tween_property(body, "velocity:x", knockback_speed_x * random_multiplier * knockback_direction, 0.05).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
	knockback_tween.tween_property(body, "velocity:x", 0.0, 0.01).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN)
	
func heavy_knockback(body:CharacterBody2D) -> void:
	print("heavy attack tween")
	var random_multiplier = rng.randf_range(heavy_knockback_min,heavy_knockback_max)
	knockback_tween.tween_property(body, "velocity:x", knockback_speed_x * random_multiplier * knockback_direction, 0.1).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
	knockback_tween.parallel().tween_property(body, "velocity:y", -knockback_speed_y, 0.01).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
	knockback_tween.tween_property(body, "velocity:x", 0.0, 0.05).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN)

func _on_knockback_motion_finished() -> void:
	knockback_finished.emit()

func _on_enemy_attack_finished() -> void:
	enemy_attack_finished.emit()
