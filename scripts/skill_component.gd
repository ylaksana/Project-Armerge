class_name SkillComponent extends Node

@export var body: Player
@export var skill_timer: Timer
@export var skills: Array[AttackData]
const FIREBALL = preload("res://scenes/fireball.tscn")

var wants_special_attack: bool = false
var spawn_delay: float
var skill: AttackData

# return whether the animated sprite playing doesn't have a loop
func non_loop_animation_playing() -> bool:
	return body.animated_sprite.is_playing() and not body.animated_sprite.sprite_frames.get_animation_loop(body.animated_sprite.animation)

func tick(delta: float) -> void:
	if body == null or body.combo_component.is_attacking:
		return
	
	if body.is_on_floor():
		if non_loop_animation_playing():
			return
		if wants_special_attack:
			fireball()
			body.combo_component.attack(true)
		

func fireball() -> void:
	body.attack_component.set_curr_atk("fireball")
	skill = body.hitbox_component.curr_atk 
	spawn_delay = skill.spawn_delay
	await get_tree().create_timer(spawn_delay).timeout
	var fireball_instance = FIREBALL.instantiate()
	get_tree().root.add_child(fireball_instance)
	fireball_instance.global_position = body.global_position
	fireball_instance.rotation = 0.0 if body.animated_sprite.flip_h else PI
	fireball_instance.hitbox_component.curr_atk = skill
