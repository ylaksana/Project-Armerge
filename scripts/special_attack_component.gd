class_name SpecialAttackComponent extends Node

@export var body: Player
@export var skill_timer: Timer
@export var SPECIAL_ATTACK: PackedScene
@export var special_attacks: Array[AttackData]

var spawn_delay: float
var curr_special_attack: AttackData

func _ready() -> void:
	call_deferred("_signals")
	
func _signals() -> void:
	body.combo_component.attack_triggered.connect(_on_attack_triggered)	

func _on_attack_triggered(animation_name: String) -> void:
	print("_on_attack_triggered: ", body.attack_component.special_attack == body.hitbox_component.curr_atk)
	if curr_special_attack:
		launch_special_attack()

func launch_special_attack() -> void:
	spawn_delay = curr_special_attack.spawn_delay
	await get_tree().create_timer(spawn_delay).timeout
	var special_attack_instance = SPECIAL_ATTACK.instantiate()
	special_attack_instance.curr_special_attack = curr_special_attack
	get_tree().root.add_child(special_attack_instance)
	special_attack_instance.global_position = body.global_position
	special_attack_instance.rotation = 0.0 if body.animated_sprite.flip_h else PI
	special_attack_instance.hitbox_component.curr_atk = curr_special_attack 
	
func set_special_attack(icon_name: String) -> void:
	var special_attack = special_attacks.filter(func(sp_atk): return icon_name == sp_atk.animation_name).front()
	if special_attack:
		curr_special_attack = special_attack
	else:
		print("Unknown or mismatched special attack name")
