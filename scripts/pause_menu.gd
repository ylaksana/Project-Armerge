extends Control

#exports
@export var killzone: Area2D
@export var player: CharacterBody2D

# child nodes
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var resume_button: Button = $PanelContainer/VBoxContainer/Resume
@onready var restart_button: Button = $PanelContainer/VBoxContainer/Restart
@onready var quit_button: Button = $PanelContainer/VBoxContainer/Quit
@onready var victory_label: Label = $PanelContainer/VBoxContainer/VictoryLabel
@onready var defeat_label: Label = $PanelContainer/VBoxContainer/DefeatLabel
@onready var pause_label: Label = $PanelContainer/VBoxContainer/PauseLabel

var won: bool = false
var lost: bool = false

func _ready() -> void:
	visible = false
	victory_label.visible = false
	defeat_label.visible = false
	animation_player.play("RESET")
	killzone.died.connect(_on_defeat)

func _process(delta : float) -> void:
	if won or lost:
		return
	if Input.is_action_just_pressed("ui_cancel"):
		if not get_tree().paused:
			pause()
		else:
			resume()

func resume() -> void:
	visible = false
	get_tree().paused = false
	print(get_tree().paused)
	animation_player.play_backwards("blur")

func pause() -> void:
	visible = true
	get_tree().paused = true
	print(get_tree().paused)
	animation_player.play("blur")
	
#func esc() -> void:
	#if wants_pause: 
		#if get_tree().paused == false:
			#pause()
		#else:
			#resume()
	

func _on_resume_pressed() -> void:
	resume()


func _on_restart_pressed() -> void:
	resume()
	get_tree().reload_current_scene()


func _on_quit_pressed() -> void:
	resume()
	get_tree().change_scene_to_file("res://scenes/main_menu.tscn")
	
func _on_victory() -> void:
	print("victory!")
	# won flag
	won = true
	get_tree().paused = true
	
	# hide these elements
	pause_label.visible = false
	resume_button.visible = false
	
	# show these elements
	visible = true
	victory_label.visible = true
	
	# blur animation
	animation_player.play("blur")
	
func _on_defeat() -> void:
	# lost flag
	lost = true
	get_tree().paused = true
	
	# hide these elements
	pause_label.visible = false
	resume_button.visible = false
	
	# show these elements
	visible = true
	defeat_label.visible = true
	
	# blur animation
	animation_player.play("blur")
	
