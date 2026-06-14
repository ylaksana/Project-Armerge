class_name HitboxComponent extends Area2D

signal hit(hurtbox)
@export var is_player: bool = true
var damage = 5

func _ready() -> void:
	#print("I am: ", get_parent().name, " hitbox layer: ", collision_layer, " mask: ", collision_mask)
	monitoring = false
	if is_player:
		monitoring = false
		collision_layer = 1
		collision_mask = 8
	else:
		print("enemy body layer: ", collision_layer, " mask: ", collision_mask)
		monitoring = true
		collision_layer = 4
		collision_mask = 2
	area_entered.connect(_on_area_entered)

func _on_area_entered(area):
	if area is HurtboxComponent:
		#monitoring = true
		area.take_hit(self)
		hit.emit(area)
