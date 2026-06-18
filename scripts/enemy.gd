extends CharacterBody2D

signal died

@onready var health_component: HealthComponent = $HealthComponent
@onready var animation_component: EnemyAnimationComponent = $AnimationComponent
@onready var movement_component: MovementComponent = $MovementComponent
@onready var hitbox_component: HitboxComponent = $HitboxComponent

func _ready() -> void:
	health_component.enemy_died.connect(_on_died)

func _physics_process(delta: float) -> void:
	hitbox_component.tick(delta)
	
func _on_died() -> void:
	died.emit()
	queue_free()
