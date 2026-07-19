class_name AilmentComponent extends Node

@export var movement_component: Node
@export var duration_timer: Timer
@export var tick_timer: Timer
@export var health_component: HealthComponent

var tick_damage: float = 0.0
var tick_duration: float = 0.0
var ailment_duration: float = 0.0

func _ready() -> void:
	duration_timer.one_shot = true

func inflict_ailment(curr_atk: AttackData) -> void:
	tick_damage = curr_atk.tick_damage
	tick_duration = curr_atk.tick_duration
	ailment_duration = curr_atk.ailment_duration
	
	print("tick_damage = ", tick_damage)
	print("tick_duration = ", tick_duration)
	print("ailment_duration = ", ailment_duration)
	
	if curr_atk.has_burn or curr_atk.has_poison:
		print("attack has burn effect")
		damage_tick()
	if curr_atk.has_freeze:
		print("attack has freeze effect")
		freeze()
	if curr_atk.has_stun:
		print("attack has stun effect")
		stun()

func damage_tick():
	print("burn ailment start")
	duration_timer.start(ailment_duration)
	tick_timer.start(tick_duration)
	
func freeze():
	print("freeze ailment start")
	movement_component.speed /= 10
	duration_timer.start(ailment_duration)
	duration_timer.timeout.connect(func(): movement_component.speed *= 10,CONNECT_ONE_SHOT)
	
# TODO: remove casting issue by adding the same states in both enemymovementcomponent and movementcomponent
func stun():
	print("stun ailment start")
	if movement_component.curr_state != EnemyMovementComponent.State.STUNNED:
		#var movement = movement_component as EnemyMovementComponent
		movement_component.save_state()
	movement_component.curr_state = EnemyMovementComponent.State.STUNNED
	duration_timer.start(ailment_duration)

func _on_ailment_timer_timeout() -> void:
	print("ailment stopped!")
	if not tick_timer.is_stopped():
		tick_timer.stop()
	#var movement = movement_component as EnemyMovementComponent
	movement_component.curr_state = movement_component.prev_state

func _on_tick_timer_timeout() -> void:
	print("tick timer timeout!")
	if not duration_timer.is_stopped():
		health_component.damage(tick_damage)
