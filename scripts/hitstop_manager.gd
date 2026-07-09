class_name HitstopManager extends Node

@export var animated_sprite: AnimatedSprite2D
@export var hurtbox: HurtboxComponent
@export var health_component: HealthComponent

func _ready() -> void:
	hurtbox.hit_received.connect(_on_hit)
	health_component.health_changed.connect(_on_health_changed)

func damage_flash() -> void:
	animated_sprite.material.set_shader_parameter("hit_flash_on",true)
	get_tree().create_timer(0.1, true, false, true).timeout.connect(
		func(): animated_sprite.material.set_shader_parameter("hit_flash_on",false)
	)

func light_hit() -> void:
	get_tree().paused = true
	await get_tree().create_timer(0.01, true).timeout
	get_tree().paused = false
	
func medium_hit() -> void:
	get_tree().paused = true
	await get_tree().create_timer(0.05, true).timeout
	get_tree().paused = false
	
func heavy_hit() -> void:
	get_tree().paused = true
	await get_tree().create_timer(0.15, true).timeout
	get_tree().paused = false
	
func on_death() -> void:
	animated_sprite.material.set_shader_parameter("hit_flash_on",true)
	get_tree().create_timer(0.4, true, false, true).timeout.connect(
		func(): animated_sprite.material.set_shader_parameter("hit_flash_on",false)
	)
	
func _on_hit(hitbox: HitboxComponent) -> void:
	var attack_type: String
	if hitbox.curr_atk != null:
		attack_type = hitbox.curr_atk.attack_weight
	else:
		attack_type = "light"
	print(animated_sprite.animation, ": ", attack_type)
	
	if attack_type == "light":
		light_hit()
	elif attack_type == "medium":
		medium_hit()
	elif attack_type == "heavy":
		heavy_hit()
		
func _on_health_changed() -> void:
	damage_flash()
