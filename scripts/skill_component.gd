class_name SkillComponent extends Node

@export var body: Player
@export var skill_timer: Timer

const FIREBALL = preload("res://scenes/fireball.tscn")

var wants_special_attack: bool = false

func tick(delta: float) -> void:
	if body == null or body.player_animation_component.is_attacking:
		return
		
	if wants_special_attack:
		print("fireball!")
		fireball()

func fireball() -> void:
	var fireball_instance = FIREBALL.instantiate()
	get_tree().root.add_child(fireball_instance)
	fireball_instance.global_position = body.global_position
	fireball_instance.rotation = 0.0 if body.animated_sprite.flip_h else PI
