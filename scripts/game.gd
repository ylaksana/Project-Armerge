extends Node2D

@onready var scene_transition: ColorRect = $SceneTransition

func _on_ready():
	scene_transition.get_node("AnimationPlayer").play("fade_out")
