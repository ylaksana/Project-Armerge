extends Node2D

@onready var fade_timer: Timer = $SceneTransition/fade_timer
@onready var scene_transition: ColorRect = $SceneTransition

var button_type = null
	

func _ready() -> void:
	print("main menu loaded")
	
func _on_start_pressed() -> void:
	print("pressed start")
	button_type = "start"
	scene_transition.show()
	fade_timer.start()
	scene_transition.get_node("AnimationPlayer").play("fade_in")

func _on_options_pressed() -> void:
	button_type = "options"
	scene_transition.show()
	fade_timer.start()
	scene_transition.get_node("AnimationPlayer").play("fade_in")


func _on_quit_pressed() -> void:
	get_tree().quit()


func _on_fade_timer_timeout() -> void:
	if button_type == "start":
		print("pressed start after timeout")
		get_tree().change_scene_to_file("res://scenes/game.tscn")
	elif button_type == "options":
		get_tree().change_scene_to_file("res://scenes/game.tscn")
