# class responsible for elemental counter reactions
class_name ElementalReactionComponent extends Node

@export var body: CharacterBody2D
@export var elemental_reaction_scene: PackedScene
@export var reactions: Array[AttackData]

var elemental_reaction_node: Node


func elemental_reaction(element_state: ElementalStateComponent.ElementState, element_attack: AttackData.ElementType) -> void:
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
	get_tree().root.add_child(elemental_reaction_node)
	elemental_reaction_node.global_position = body.global_position
	set_reaction("scorchspark")
	if not body.is_flying:
		if body.is_on_floor():
			var body_shape = body.get_node("body").shape as RectangleShape2D
			var body_bottom = body.global_position.y + body_shape.size.y / 2
			elemental_reaction_node.global_position.y = body_bottom - (elemental_reaction_node.global_position.y / 2)
			elemental_reaction_node.scorchspark_on_floor()
	else:
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
	
func set_reaction(reaction_name: String) -> void:
	var reaction = reactions.filter(func(r): return reaction_name == r.animation_name).front()
	print("set reaction to: ", reaction)
	if reaction and elemental_reaction_node:
		elemental_reaction_node.hitbox_component.curr_atk = reaction
	else:
		print("Unknown or mismatched special attack name")
