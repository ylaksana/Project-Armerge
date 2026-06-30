extends Node2D

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D

const SPEED: int = 200

func _ready() -> void:
	animated_sprite.play("fireball")

func _process(delta: float) -> void:
	position += transform.x * SPEED * delta
