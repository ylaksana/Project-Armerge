extends AnimatedSprite2D
func hit() -> void:
	play("hit")
	animation_finished.connect(queue_free)
	
func detect() -> void:
	play("detected")
	animation_finished.connect(queue_free)
