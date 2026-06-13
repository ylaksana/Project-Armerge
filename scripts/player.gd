class_name Player extends CharacterBody2D
@onready var input_component: InputComponent = $InputComponent
@onready var movement_component: MovementComponent = $MovementComponent
@onready var hurtbox_component: HurtboxComponent = $HurtboxComponent
@onready var hitbox_component: HitboxComponent = $HitboxComponent
@onready var health_component: HealthComponent = $HealthComponent


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
	
func _on_died()->void:
	queue_free()
