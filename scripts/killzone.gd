extends Area2D

@onready var timer: Timer = $Timer
signal died

func _on_body_entered(body: Node2D) -> void:
	died.emit()
	print("player hit out of bounds!")
	
