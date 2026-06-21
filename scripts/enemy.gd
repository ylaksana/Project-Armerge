extends CharacterBody2D

signal died

@onready var health_component: HealthComponent = $HealthComponent
@onready var movement_component: MovementComponent = $MovementComponent
@onready var hitbox_component: HitboxComponent = $HitboxComponent
@onready var enemy_animation_component: EnemyAnimationComponent = $EnemyAnimationComponent
@onready var enemy_movement_component: EnemyMovementComponent = $EnemyMovementComponent


func _ready() -> void:
	health_component.enemy_died.connect(_on_died)

func _physics_process(delta: float) -> void:
	hitbox_component.tick(delta)
	enemy_animation_component.tick(delta)
	enemy_movement_component.tick(delta)
	
	
func _on_died() -> void:
	died.emit()
	queue_free()
	
	
