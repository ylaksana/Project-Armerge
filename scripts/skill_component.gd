class_name SkillComponent extends Node

@export var body: Player
@export var skill_timer: Timer
@export var skills: Array[AttackData]
const FIREBALL = preload("res://scenes/fireball.tscn")

var spawn_delay: float
var skill: AttackData

func _ready() -> void:
	call_deferred("_signals")
	
func _signals() -> void:
	body.combo_component.attack_triggered.connect(_on_attack_triggered)	

func _on_attack_triggered(animation_name: String) -> void:
	print("_on_attack_triggered: ", body.attack_component.special_attack == body.hitbox_component.curr_atk)
	if body.attack_component.special_attack == body.hitbox_component.curr_atk:
		fireball()

func fireball() -> void:
	skill = body.hitbox_component.curr_atk 
	spawn_delay = skill.spawn_delay
	await get_tree().create_timer(spawn_delay).timeout
	var fireball_instance = FIREBALL.instantiate()
	get_tree().root.add_child(fireball_instance)
	fireball_instance.global_position = body.global_position
	fireball_instance.rotation = 0.0 if body.animated_sprite.flip_h else PI
	fireball_instance.hitbox_component.curr_atk = skill
