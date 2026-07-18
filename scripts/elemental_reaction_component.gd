# class responsible for elemental counter reactions
class_name ElementalReactionComponent extends Node

func reaction(element_state: ElementalStateComponent.ElementState, element_attack: AttackData.ElementType) -> void:
	if element_state == ElementalStateComponent.ElementState.FIRE and element_attack == AttackData.ElementType.ELECTRIC:
		combust()
	elif element_state == ElementalStateComponent.ElementState.FIRE and element_attack == AttackData.ElementType.WIND:
		ignite()
	
# TODO - elemental reactions
# fire -> lightning
func combust() -> void:
	pass
	
# lightning -> fire
func supercombust() -> void:
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
