class_name SpecialAttack extends Node2D

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var hitbox_component: HitboxComponent = $HitboxComponent

var curr_special_attack: AttackData
var speed: float = 0.0

func _ready() -> void:
	if curr_special_attack:
		speed = curr_special_attack.projectile_speed
		animated_sprite.play(curr_special_attack.animation_name)
		hitbox_component.monitoring = true
		hitbox_component.hit.connect(_on_hit)
		hitbox_component.curr_atk = curr_special_attack
		get_tree().create_timer(curr_special_attack.projectile_duration).timeout.connect(_on_hit)
	

func _process(delta: float) -> void:
	position += transform.x * speed * delta


func _on_hit() -> void:
	hitbox_component.set_deferred("monitoring", false)
	queue_free()
	

	
