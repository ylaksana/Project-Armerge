# class responsible for elemental counter reactions
class_name ElementalReactionComponent extends Node

@export var body: CharacterBody2D
@export var elemental_reaction_scene: PackedScene

var elemental_reaction_node: Node

func reaction(element_state: ElementalStateComponent.ElementState, element_attack: AttackData.ElementType) -> void:
	if element_state == ElementalStateComponent.ElementState.NONE:
		return
	
	create_reaction_vfx()
	
	if elemental_reaction_node:
		print("element_state: ", element_state)
		print("element_attack: ", element_attack)
		print("created reaction scene")
		if element_state == ElementalStateComponent.ElementState.FIRE and element_attack == AttackData.ElementType.ELECTRIC:
			print("scorchspark!")
			scorchspark()
		elif element_state == ElementalStateComponent.ElementState.FIRE and element_attack == AttackData.ElementType.WIND:
			ignite()
		else:
			elemental_reaction_node._on_finished()
		
	
# TODO - elemental reactions
# fire -> lightning
func scorchspark() -> void:
	elemental_reaction_node.global_position = body.global_position
	elemental_reaction_node.scorchspark()
	
# lightning -> fire
func flamecharged() -> void:
	pass
	
#wind -> lightning
func storm() -> void:
	pass

# ice -> lightning
func supercharged() -> void:
	pass

# wind -> fire
func ignite() -> void:
	pass
	
func create_reaction_vfx() -> void:
	if elemental_reaction_node:
		elemental_reaction_node._on_finished()
	elemental_reaction_node = elemental_reaction_scene.instantiate()
	body.add_child(elemental_reaction_node)
