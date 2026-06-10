class_name InputComponent extends Node

var jump_pressed : bool = false
var attack_pressed: bool = false
var dir: float = 0.0


func update() -> void:
	dir = Input.get_axis("left","right")
	jump_pressed = Input.is_action_just_pressed("jump")
	attack_pressed = Input.is_action_just_pressed("attack")
	
