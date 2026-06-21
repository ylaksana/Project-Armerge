class_name HealthComponent extends ProgressBar

signal health_changed(curr:float,max:float)
signal died
signal enemy_died

@export var max_health: float = 100.0
@export var hurtbox: HurtboxComponent
@export var is_player: bool = true
@export var animated_sprite: AnimatedSprite2D
@onready var reset_scene_timer: Timer = $ResetSceneTimer

var curr_health : float = 0.0
var is_hit : bool = false
var change_value_tween: Tween
var opacity_tween: Tween

func _ready() -> void:
	#print("ResetVisibility node: ", $ResetVisibility)
	curr_health = max_health
	_setup_health_bar(curr_health)
	hurtbox.hit_received.connect(damage)
	_emit()
	
func _setup_health_bar(max_val: float) -> void:
	modulate.a = 0.0
	value = max_val
	max_value = max_val

func _change_opacity(new_amount: float) -> void:
	if opacity_tween:
		opacity_tween.kill()
	opacity_tween = create_tween()
	opacity_tween.tween_property(self, "modulate:a",new_amount, 0.12).set_trans(Tween.TRANS_SINE)

func change_value(new_value: float) -> void:
	_change_opacity(1.0)
	await opacity_tween.finished
	
	value = new_value
	
	if change_value_tween:
		change_value_tween.kill()
		
	change_value_tween = create_tween()
	change_value_tween.finished.connect($ResetVisibility.start)
	change_value_tween.tween_property(self, "value", new_value, 0.35).set_trans(Tween.TRANS_SINE)

func _emit() -> void:
	health_changed.emit(curr_health, max_health)
	
func damage(hitbox: HitboxComponent) -> void:
	#print("Damage taken!")
	curr_health = clamp(curr_health - hitbox.damage, 0.0, max_health)
	
	# hitstop
	get_tree().paused = true
	await get_tree().create_timer(0.1, true).timeout
	get_tree().paused = false
	
	animated_sprite.material.set_shader_parameter("hit_flash_on",true)
	await get_tree().create_timer(0.05, true, false, true).timeout
	animated_sprite.material.set_shader_parameter("hit_flash_on", false)
	_emit()
	change_value(curr_health)
	if curr_health == 0.0:
		if is_player:
			died.emit()
		else:
			enemy_died.emit()

func _on_reset_visibility_timeout() -> void:
	_change_opacity(0.0)
	
