class_name Enemy extends CharacterBody2D

signal died

@export var player: Player
@export var is_flying: bool = false
@onready var health_component: HealthComponent = $HealthComponent
@onready var hitbox_component: HitboxComponent = $HitboxComponent
@onready var enemy_animation_component: EnemyAnimationComponent = $EnemyAnimationComponent
@onready var enemy_movement_component: EnemyMovementComponent = $EnemyMovementComponent
@onready var animated_components: AnimationPlayer = $AnimatedComponents
@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var attack_component: AttackComponent = $AttackComponent
@onready var elemental_state_component: ElementalStateComponent = $ElementalStateComponent
@onready var ailment_component: AilmentComponent = $AilmentComponent
@onready var vfx_manager: VFXManager = $VFXManager
@onready var spike: CollisionShape2D = $spike
@onready var body: CollisionShape2D = $body
@onready var flying_body: CollisionShape2D = $flying_body
@onready var ground_hurtbox: CollisionShape2D = $HurtboxComponent/ground_hurtbox
@onready var flying_hurtbox: CollisionShape2D = $HurtboxComponent/flying_hurtbox


func _ready() -> void:
	health_component.enemy_died.connect(_on_died)
	hitbox_component.monitoring = true
	if is_flying:
		spike.disabled = true
		body.disabled = true
		hitbox_component.monitoring = false
		ground_hurtbox.disabled = true
	else:
		flying_hurtbox.disabled = true
		flying_body.disabled = true

func _physics_process(delta: float) -> void:
	#hitbox_component.tick(delta)
	enemy_animation_component.tick(delta)
	enemy_movement_component.tick(delta)
	elemental_state_component.tick()
	
func _on_died() -> void:
	died.emit()
	self.collision_layer = 0
	self.collision_mask = 1
	await get_tree().create_timer(0.35, true).timeout
	health_component.is_dying = false
	queue_free()
