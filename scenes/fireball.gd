extends Node2D

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var hitbox_component: HitboxComponent = $HitboxComponent

const SPEED: int = 300

func _ready() -> void:
	animated_sprite.play("fireball")
	hitbox_component.monitoring = true
	hitbox_component.hit.connect(_on_hit)
	get_tree().create_timer(0.5).timeout.connect(_on_hit)
	

func _process(delta: float) -> void:
	position += transform.x * SPEED * delta


func _on_hit() -> void:
	queue_free()
