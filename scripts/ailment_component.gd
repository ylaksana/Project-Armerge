class_name AilmentComponent extends Node

@export var body: CharacterBody2D
@export var duration_timer: Timer
@export var tick_timer: Timer
@export var health_component: HealthComponent

var tick_damage: float = 0.0
var tick_duration: float = 0.0
var ailment_duration: float = 0.0

func inflict_ailment(curr_atk: AttackData) -> void:
	tick_damage = curr_atk.tick_damage
	tick_duration = curr_atk.tick_duration
	ailment_duration = curr_atk.ailment_duration
	print("tick_damage = ", tick_damage)
	print("tick_duration = ", tick_duration)
	print("ailment_duration = ", ailment_duration)
	
	if curr_atk.has_burn:
		print("attack has burn effect")
		burn()
	if curr_atk.has_freeze:
		print("attack has freeze effect")
		freeze()
	if curr_atk.has_poison:
		print("attack has poison effect")
		poison()
	if curr_atk.has_stun:
		print("attack has stun effect")
		stun()

func burn():
	print("burn ailment start")
	duration_timer.one_shot = true
	duration_timer.start(ailment_duration)
	tick_timer.start(tick_duration)
	
func poison():
	pass
	
func freeze():
	pass
	
func stun():
	pass

func _on_ailment_timer_timeout() -> void:
	print("ailment stopped!")
	tick_timer.stop()

func _on_tick_timer_timeout() -> void:
	print("tick timer timeout!")
	if not duration_timer.is_stopped():
		health_component.damage(tick_damage)
