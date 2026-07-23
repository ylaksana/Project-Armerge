extends AnimatedSprite2D

@onready var animation_player: AnimationPlayer = $AnimationPlayer

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

func freeze(timer:Timer) -> void:
	play("freeze")
	timer.timeout.connect(_on_finished, CONNECT_ONE_SHOT)
	
func electric_stun(timer: Timer) -> void:
	play("electric_stun")
	timer.timeout.connect(_on_finished, CONNECT_ONE_SHOT)
	
func electric_afflict(timer: Timer) -> void:
	play("electric_afflict")
	timer.timeout.connect(_on_finished, CONNECT_ONE_SHOT)
	
func fire_afflict(timer: Timer) -> void:
	play("fire_afflict")
	timer.timeout.connect(_on_finished, CONNECT_ONE_SHOT)
	
func ice_afflict(timer: Timer) -> void:
	play("ice_afflict")
	timer.timeout.connect(_on_finished, CONNECT_ONE_SHOT)
	
func _on_finished() -> void:
	queue_free()
