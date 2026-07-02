class_name VFXManager extends Node

signal vfx_freed(exists: bool)

# vfx
@export var vfx_scene: PackedScene

var detect_vfx_node: Node
var hit_vfx_node: Node
 

func detected_vfx(body: CharacterBody2D) -> void:
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
