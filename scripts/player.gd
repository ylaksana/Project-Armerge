class_name Player extends CharacterBody2D
@onready var input_component: InputComponent = $InputComponent
@onready var movement_component: MovementComponent = $MovementComponent
@onready var hurtbox_component: HurtboxComponent = $HurtboxComponent
@onready var hitbox_component: HitboxComponent = $HitboxComponent
@onready var health_component: HealthComponent = $HealthComponent
@onready var pause_menu: Control = $"../CanvasLayer/pause_menu"


func _ready() -> void:
	health_component.died.connect(_on_died)

func _physics_process(delta: float) -> void:
	# read controls from input
	input_component.update()
	
	#read movement from input
	movement_component.dir = input_component.dir
	movement_component.wants_jump = input_component.jump_pressed
	movement_component.wants_attack = input_component.attack_pressed
	movement_component.tick(delta)
	
	
	
func _on_died() -> void:
	self.collision_mask = 1
	var tween = create_tween()
	tween.tween_property(self, "velocity:x", 0.0, 0.4).set_trans(Tween.TRANS_SINE)
	movement_component.animated_sprite.play("death")
	movement_component.is_dead = true
	health_component.reset_scene_timer.start()
	health_component.reset_scene_timer.timeout.connect(_on_timer_timeout)
	
	
func _on_timer_timeout() -> void:
	get_tree().reload_current_scene()
	
	
	

	
