extends Node2D

@onready var scene_transition: ColorRect = $SceneTransition
@onready var pause_menu: Control = $CanvasLayer/pause_menu
@onready var enemies: Node = $enemies
@onready var victory_timer: Timer = $VictoryTimer

var total_enemies: int = 0
var points: int = 0

func _ready():
	victory_timer.timeout.connect(_on_timer_timeout)
	scene_transition.get_node("AnimationPlayer").play("fade_out")
	for enemy in enemies.get_children():
		total_enemies += 1
		enemy.died.connect(_on_enemy_died)
		
func _on_enemy_died() -> void:
	#print("Enemy slain!")
	points += 1
	if points > 0: 
		_on_victory()
		
func _on_victory() -> void:
	#print("Victory")
	victory_timer.start()
	
func _on_timer_timeout() -> void:
	pause_menu._on_victory()
