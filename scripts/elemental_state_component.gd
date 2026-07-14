class_name ElementalStateComponent extends Node

@export var hitbox: HitboxComponent
@export var elemental_cooldown_timer: Timer
@export var reaction_cooldown: float = 1.0

@export var reaction_component: ElementalReactionComponent

enum ElementState{
	NONE,
	ICE,
	FIRE,
	ELECTRIC
}

var curr_elemental_state: ElementState = ElementState.NONE

func _ready() -> void:
	hitbox.hit.connect(_on_hit)
	
func _on_hit() -> void:
	# if cooldown timer stopped:
	if not elemental_cooldown_timer.is_stopped():
		# apply the element:
		if curr_elemental_state == ElementState.NONE:
			apply_element()
		else:
			reaction_component.elemental_reaction()
			
	
	# if cooldown timer is still active:
	
func apply_element() -> void:
	if hitbox.curr_atk and hitbox.curr_atk.has_element:
		if hitbox.curr_atk.element_type == AttackData.ElementType.FIRE:
			curr_elemental_state = ElementState.FIRE
		elif hitbox.curr_atk.element_type == AttackData.ElementType.ICE:
			curr_elemental_state = ElementState.ICE
		elif hitbox.curr_atk.element_type == AttackData.ElementType.ELECTRIC:
			curr_elemental_state = ElementState.ELECTRIC
