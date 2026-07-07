class_name Player extends CharacterBody2D

@onready var input_component: InputComponent = $InputComponent
@onready var movement_component: MovementComponent = $MovementComponent
@onready var hurtbox_component: HurtboxComponent = $HurtboxComponent
@onready var hitbox_component: HitboxComponent = $HitboxComponent
@onready var health_component: HealthComponent = $HealthComponent
@onready var player_animation_component: PlayerAnimationComponent = $PlayerAnimationComponent
@onready var pause_menu: Control = $"../CanvasLayer/pause_menu"
@onready var skill_component: SkillComponent = $SkillComponent
@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var body_collision: CollisionShape2D = $CollisionShape2D
@onready var pivot_component: PivotComponent = $PivotComponent
@onready var attack_component: AttackComponent = $AttackComponent
@onready var combo_component: ComboComponent = $ComboComponent
@onready var skill_timer: Timer = $Timers/SkillTimer
@onready var combo_timer: Timer = $Timers/ComboTimer
@onready var special_attack_wheel: Node = $SpecialAttackWheel

func _ready() -> void:
	health_component.died.connect(_on_died)

func _physics_process(delta: float) -> void:
	# read controls from input
	input_component.update()
	# read movement from input
	movement_component.dir = input_component.dir
	movement_component.wants_jump = input_component.jump_pressed
	movement_component.wants_attack = input_component.attack_pressed
	combo_component.wants_special_attack = input_component.special_attack_pressed
	special_attack_wheel.toggle_pressed = input_component.sp_atk_wheel_pressed
	special_attack_wheel.toggle_released = input_component.sp_atk_wheel_released
	special_attack_wheel.tick(delta)
	player_animation_component.tick(delta)
	movement_component.tick(delta)
	combo_component.tick(delta)
	
func _on_died() -> void:
	self.collision_layer = 0
	self.collision_mask = 1
	var tween = create_tween()
	tween.tween_property(self, "velocity:x", 0.0, 0.4).set_trans(Tween.TRANS_SINE)
	player_animation_component.animated_sprite.play("death")
	player_animation_component.is_dead = true
	movement_component.is_dead = true
	
	hitbox_component.curr_atk = null
	health_component.reset_scene_timer.start()
	health_component.reset_scene_timer.timeout.connect(_on_timer_timeout)

func _on_timer_timeout() -> void:
	pause_menu._on_defeat()
