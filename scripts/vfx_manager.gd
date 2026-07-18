class_name VFXManager extends Node

signal vfx_freed(exists: bool)

# vfx
@export var body: CharacterBody2D
@export var vfx_scene: PackedScene

var detect_vfx_node: Node
var hit_vfx_node: Node
var fireball_hit_vfx_node: Node
var ailment_vfx_node: Node
var elemental_state_vfx_node: Node

func detected_vfx() -> void:
	if vfx_scene:
		var body_shape: RectangleShape2D = body.get_node("body").shape as RectangleShape2D
		var position: Vector2
		if body.animated_sprite.flip_h: 
			position = body.get_node("body").global_position + Vector2(-body_shape.size.x/2, -body_shape.size.y)
		else:
			position = body.get_node("body").global_position + Vector2(body_shape.size.x/2, -body_shape.size.y)
		detect_vfx_node = vfx_scene.instantiate()
		get_tree().root.add_child(detect_vfx_node)
		detect_vfx_node.global_position = position
		detect_vfx_node.detect()
		detect_vfx_node.finished.connect(func(): vfx_freed.emit(false), CONNECT_ONE_SHOT)
	else:
		vfx_freed.emit(false)
			
func hit_vfx(body: CharacterBody2D)-> void:
	#print("hit vfx activated!")
	#print(hit_vfx)
	if hit_vfx:
		#print("hit vfx activated!")
		var position = body.get_node("body").global_position
		hit_vfx_node = vfx_scene.instantiate()
		get_tree().root.add_child(hit_vfx_node)
		hit_vfx_node.global_position = position
		hit_vfx_node.hit()
		
func fireball_hit_vfx()-> void:
	#print("hit vfx activated!")
	#print(hit_vfx)
	if hit_vfx:
		#print("hit vfx activated!")
		var position = body.get_node("body").global_position
		fireball_hit_vfx_node = vfx_scene.instantiate()
		get_tree().root.add_child(fireball_hit_vfx_node)
		fireball_hit_vfx_node.global_position = position
		fireball_hit_vfx_node.fireball_hit()

func burn_vfx() -> void:
	ailment_vfx_node.burn(body.ailment_component.duration_timer)

func freeze_vfx() -> void:
	ailment_vfx_node.freeze(body.ailment_component.duration_timer)
	
func stun_vfx() -> void:
	body.add_child(ailment_vfx_node)
	ailment_vfx_node.electric_stun(body.ailment_component.duration_timer)
	
func poison_vfx() -> void:
	pass
	
func _on_ailment(curr_atk: AttackData):
	if ailment_vfx_node:
		ailment_vfx_node._on_finished()
	ailment_vfx_node = vfx_scene.instantiate()
	body.add_child(ailment_vfx_node)
	if curr_atk.has_burn:
		print("attack has burn effect")
		burn_vfx()
	if curr_atk.has_freeze:
		print("attack has freeze effect")
		freeze_vfx()
	if curr_atk.has_poison:
		print("attack has poison effect")
		poison_vfx()
	if curr_atk.has_stun:
		print("attack has stun effect")
		stun_vfx()

func fire_afflict() -> void:
	elemental_state_vfx_node.fire_afflict(body.elemental_state_component.elemental_residue_timer)
	
func electric_afflict() -> void:
	elemental_state_vfx_node.electric_afflict(body.elemental_state_component.elemental_residue_timer)
	
func ice_afflict() -> void:
	elemental_state_vfx_node.ice_afflict(body.elemental_state_component.elemental_residue_timer)
	
func elemental_afflict(curr_elemental_state: ElementalStateComponent.ElementState) -> void:
	if elemental_state_vfx_node:
		ailment_vfx_node._on_finished()
	elemental_state_vfx_node = vfx_scene.instantiate()
	body.add_child(elemental_state_vfx_node)
	elemental_state_vfx_node.global_position = body.global_position + Vector2(0, -25)
	if curr_elemental_state == ElementalStateComponent.ElementState.FIRE:
		print("attack has burn effect")
		fire_afflict()
	elif curr_elemental_state == ElementalStateComponent.ElementState.ICE:
		print("attack has freeze effect")
		ice_afflict()
	elif curr_elemental_state == ElementalStateComponent.ElementState.ELECTRIC:
		print("attack has electric effect")
		electric_afflict()
