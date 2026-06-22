class_name HitstopManager extends Node

@export var animated_sprite: AnimatedSprite2D
@export var hurtbox: HurtboxComponent

var attack_pairs = {
		"basicattack_1": "light",
		"basicattack_2": "light",
		"basicattack_3": "light"
	}
	
func _ready() -> void:
	hurtbox.hit_received.connect(_on_hit)

func light_hit() -> void:
	get_tree().paused = true
	await get_tree().create_timer(0.1, true).timeout
	get_tree().paused = false
	
func medium_hit() -> void:
	pass
	get_tree().paused = true
	await get_tree().create_timer(0.2, true).timeout
	get_tree().paused = false
	
func heavy_hit() -> void:
	get_tree().paused = true
	await get_tree().create_timer(0.3, true).timeout
	get_tree().paused = false
	
func _on_hit(hitbox: HitboxComponent) -> void:
	var attack_type: String = attack_pairs.get(hitbox.animated_sprite.animation, "")
	if attack_type == "light":
		light_hit()
	elif attack_type == "medium":
		medium_hit()
	elif attack_type == "heavy":
		heavy_hit()
