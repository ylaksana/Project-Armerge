class_name HitboxComponent extends Area2D

@export var hitbox_shape: CollisionShape2D
@export var passive_attack: AttackData

signal hit

var has_hit: bool = false
var right_hit: bool = false
var damage: float
var curr_atk: AttackData

func _ready() -> void:
	#print("I am: ", get_parent().name, " hitbox layer: ", collision_layer, " mask: ", collision_mask)
	monitoring = false
	area_entered.connect(_on_area_entered)
	area_exited.connect(_on_area_exited)
	

func _on_area_entered(area):
	#print(self.owner, " hit ", area.owner)
	if area is HurtboxComponent and not has_hit:
		#print(self.owner, " hit ", area.owner)
		has_hit = true
		if curr_atk:
			damage = curr_atk.damage
			print("active damage: ", damage, " damage!")
		else:
			damage = passive_attack.damage if passive_attack else 0.0
			print("passive damage: ", damage, " damage!")
		print("curr_atk damage: ", damage)
		right_hit = global_position.x > area.global_position.x
		print("hit")
		area.take_hit(self)
		hit.emit()
		
func _on_area_exited(area):
	if area is HurtboxComponent and has_hit:
		monitoring = false
		has_hit = false
