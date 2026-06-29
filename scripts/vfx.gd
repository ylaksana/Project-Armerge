extends AnimatedSprite2D

signal finished

func hit() -> void:
	play("hit")
	queue_free()
	
func detect() -> void:
	play("detected")
	animation_finished.connect(_on_finished)


func _on_finished() -> void:
	finished.emit()
	queue_free()
