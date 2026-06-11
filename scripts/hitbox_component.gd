class_name HitboxComponent extends Area2D

signal hit(hurtbox)

func _on_area_entered(area):
	if area.is_in_group("hurtbox"):
		hit.emit(area)
