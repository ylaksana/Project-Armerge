class_name Enemy extends CharacterBody2D

signal died

@export var player: Player
@onready var health_component: HealthComponent = $HealthComponent
@onready var hitbox_component: HitboxComponent = $HitboxComponent
@onready var enemy_animation_component: EnemyAnimationComponent = $EnemyAnimationComponent
@onready var enemy_movement_component: EnemyMovementComponent = $EnemyMovementComponent
@onready var animated_components: AnimationPlayer = $AnimatedComponents
@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var attack_component: AttackComponent = $AttackComponent


func _ready() -> void:
	health_component.enemy_died.connect(_on_died)
	hitbox_component.monitoring = true

func _physics_process(delta: float) -> void:
	#hitbox_component.tick(delta)
	enemy_animation_component.tick(delta)
	enemy_movement_component.tick(delta)
	
func _on_died() -> void:
	died.emit()
	await get_tree().create_timer(0.35, true).timeout
	health_component.is_dying = false
	queue_free()
