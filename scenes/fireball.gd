extends Node2D

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var hitbox_component: HitboxComponent = $HitboxComponent

const SPEED: int = 200

func _ready() -> void:
	animated_sprite.play("fireball")
	hitbox_component.monitoring = true
	

func _process(delta: float) -> void:
	position += transform.x * SPEED * delta
