class_name InputComponent extends Node

var jump_pressed : bool = false
var attack_pressed: bool = false
var dir: float = 0.0
var special_attack_pressed: bool = false
var sp_atk_wheel_pressed: bool = false
var sp_atk_wheel_released: bool = false


func update() -> void:
	dir = Input.get_axis("left","right")
	jump_pressed = Input.is_action_just_pressed("jump")
	attack_pressed = Input.is_action_just_pressed("attack")
	special_attack_pressed = Input.is_action_just_pressed("special_attack")
	sp_atk_wheel_pressed = Input.is_action_just_pressed("special_attack_select")
	sp_atk_wheel_released = Input.is_action_just_released("special_attack_select")
