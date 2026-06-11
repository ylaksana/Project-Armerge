class_name HitboxComponent extends Area2D

signal hit(hurtbox)

func _ready() -> void:
	print("I am: ", get_parent().name, " hitbox layer: ", collision_layer, " mask: ", collision_mask)
	monitoring = false
	area_entered.connect(_on_area_entered)

func _on_area_entered(area):
	if area is HurtboxComponent:
		area.take_hit(self)
		hit.emit(area)
