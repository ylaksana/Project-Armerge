extends CharacterBody2D

signal died

@onready var health_component: HealthComponent = $HealthComponent

func _ready() -> void:
	health_component.enemy_died.connect(_on_died)
	
func _on_died() -> void:
	died.emit()
	queue_free()
