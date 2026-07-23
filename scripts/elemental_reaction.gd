extends AnimatedSprite2D


@onready var hitbox_component: HitboxComponent = $HitboxComponent


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	hitbox_component.monitoring = false
	
func scorchspark() -> void:
	pass

func _on_finished() -> void:
	queue_free()
