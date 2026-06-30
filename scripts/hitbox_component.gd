class_name HitboxComponent extends Area2D

@export var hitbox_shape: CollisionShape2D
@export var attack_component: AttackComponent

var has_hit: bool = false
var right_hit: bool = false

func _ready() -> void:
	#print("I am: ", get_parent().name, " hitbox layer: ", collision_layer, " mask: ", collision_mask)
	monitoring = false
	area_entered.connect(_on_area_entered)
	area_exited.connect(_on_area_exited)

func _on_area_entered(area):
	if area is HurtboxComponent:
		has_hit = true
		if attack_component.curr_atk:
			attack_component.damage = attack_component.curr_atk.damage
		right_hit = global_position.x > area.global_position.x
		area.take_hit(self)
		
func _on_area_exited(area):
	print("curr_atk = ", attack_component.curr_atk)
	if area is HurtboxComponent and attack_component.curr_atk == null:
		set_deferred("monitoring", false)
		await get_tree().create_timer(0.5, true).timeout
		set_deferred("monitoring", true)
