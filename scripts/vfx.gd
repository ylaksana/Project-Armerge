extends AnimatedSprite2D

signal finished

func hit() -> void:
	play("hit")
	animation_finished.connect(_on_finished)
	
func fireball_hit() -> void:
	play("fireball_hit")
	animation_finished.connect(_on_finished)
	
func detect() -> void:
	play("detected")
	
	animation_finished.connect(func():
		finished.emit()
		_on_finished()
	)
	
func burn(timer: Timer) -> void:
	play("burn")
	timer.timeout.connect(_on_finished, CONNECT_ONE_SHOT)

func _on_finished() -> void:
	queue_free()
