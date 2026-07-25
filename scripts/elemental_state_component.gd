class_name ElementalStateComponent extends Node

@export var body: CharacterBody2D
@export var hurtbox: HurtboxComponent
@export var elemental_cooldown_timer: Timer
@export var elemental_residue_timer: Timer
@export var reaction_cooldown_duration: float = 1.0
@export var residue_duration: float = 5.0
@export var reaction_component: ElementalReactionComponent

enum ElementState{
	NONE,
	ICE,
	FIRE,
	ELECTRIC
}

var curr_elemental_state: ElementState = ElementState.NONE

func _ready() -> void:
	hurtbox.hit_received.connect(_on_hit_received)
	elemental_cooldown_timer.one_shot = true
	elemental_residue_timer.one_shot = true
	
func tick() -> void:
	element_vfx()
	
func _on_hit_received(hitbox: HitboxComponent) -> void:
	print("elemental cooldown timer stopped = ", elemental_cooldown_timer.is_stopped())
	# we can apply an element again
	if hitbox.curr_atk.has_element:
		if elemental_cooldown_timer.is_stopped():
			# apply the element:
			if curr_elemental_state == ElementState.NONE:
				print("applying elemental state to unafflicted entity")
				apply_element(hitbox.curr_atk)
				elemental_residue_timer.start(residue_duration)
				
			else:
				print("curr_elemental_state = ", ElementState.keys()[curr_elemental_state])
				print("attacking element = ", AttackData.ElementType.keys()[hitbox.curr_atk.element_type])
				if ElementState.keys()[curr_elemental_state] == AttackData.ElementType.keys()[hitbox.curr_atk.element_type]:
					print("apply the curr_elemental_state again!")
					elemental_residue_timer.start(residue_duration)
				else:
					print("elemental reaction!")
					elemental_residue_timer.stop()
					elemental_cooldown_timer.start(reaction_cooldown_duration)
					reaction_component.elemental_reaction(curr_elemental_state, hitbox.curr_atk.element_type)
					curr_elemental_state = ElementState.NONE
		# we can't apply a reaction at this moment, but we can reapply the current element
		else:
			if ElementState.keys()[curr_elemental_state] == AttackData.ElementType.keys()[hitbox.curr_atk.element_type]:
				print("apply the curr_elemental_state again!")
				elemental_residue_timer.start(residue_duration)
				
		body.vfx_manager.elemental_afflict(curr_elemental_state)
		
		
	#else:
		#print("case not covered")
		#print("curr_elemental_state = ", curr_elemental_state)
		#print("attacking element type = ", hitbox.curr_atk.element_type)
			
	# if cooldown timer is still active:
	
func apply_element(curr_atk: AttackData) -> void:
	print("curr_elemental_state = ", curr_elemental_state)
	print("applying element = ", curr_atk.element_type)
	if curr_atk and curr_atk.has_element:
		if curr_atk.element_type == AttackData.ElementType.FIRE:
			curr_elemental_state = ElementState.FIRE
		elif curr_atk.element_type == AttackData.ElementType.ICE:
			curr_elemental_state = ElementState.ICE
		elif curr_atk.element_type == AttackData.ElementType.ELECTRIC:
			curr_elemental_state = ElementState.ELECTRIC
		
			
func element_vfx() -> void:
	#print("current element afflicted: ", ElementState.keys()[curr_elemental_state])
	if curr_elemental_state == ElementState.FIRE:
		body.animated_sprite.modulate = Color("ffa500ff")
	elif curr_elemental_state == ElementState.ICE:
		body.animated_sprite.modulate = Color("abffffff")
	elif curr_elemental_state == ElementState.ELECTRIC:
		body.animated_sprite.modulate = Color("ffff00ff")
	else:
		body.animated_sprite.modulate = Color("WHITE")
		


func _on_elemental_residue_timer_timeout() -> void:
	print("elemental residue cleared!")
	curr_elemental_state = ElementState.NONE
