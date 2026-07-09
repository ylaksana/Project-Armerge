class_name EnemyMovementComponent extends Node

# nodes
@export var body: Enemy
@export var animated_sprite: AnimatedSprite2D
@export var hurtbox: HurtboxComponent
@export var raycast_timer: Timer
@export var front_raycast: RayCast2D
@export var rear_raycast: RayCast2D
@export var tween: TweenManager
@export var vfx: VFXManager


# parameters
@export var speed: int = 25
@export var chase_speed: int = 75
@export var jump: float = 6.0
@export var gravity_multiplier: float = 3.0
@export var acceleration: int = 300
@export var attack_cooldown: float = 0.5
@export var front_raycast_len: float = 125
@export var rear_raycast_len: float = 30

# enemy state
enum State{
	WANDER,
	CHASE,
	ATTACK,
	STUNNED
}

# variables
var direction: Vector2
var right_bounds: Vector2
var left_bounds: Vector2
var prev_state = State.WANDER
var curr_state = State.WANDER
var on_cooldown: bool = false
var on_rear_side : bool = true
var vfx_exists: bool

func _ready() -> void:
	hurtbox.hit_received.connect(_on_hit_received)
	tween.knockback_finished.connect(restore_state)
	tween.enemy_attack_finished.connect(attack_finished)
	vfx.vfx_freed.connect(vfx_state)
	left_bounds = body.position + Vector2(-125,0)
	right_bounds = body.position + Vector2(125,0)

func tick(delta: float):
	if body == null or body.player.health_component.curr_health <= 0 or vfx_exists:
		return
	#print(State.keys()[curr_state])
	
	# always affects the enemy
	gravity(delta)
	
	if curr_state in [State.ATTACK, State.STUNNED]:
		body.move_and_slide()
		return
		
	# AI resumes if not hit
	movement(delta)
	wander()
	body.move_and_slide()
	change_direction()
		
	# attack logic
	if body.global_position.distance_to(body.player.global_position) < 22.0 and not on_cooldown:
		attack()
	
func wander():
	if front_raycast.is_colliding():
		var collider = front_raycast.get_collider()
		if collider == body.player:
			chase()
		elif curr_state == State.CHASE:
			stop_chase()
	if rear_raycast.is_colliding():
		var collider = rear_raycast.get_collider()
		if collider == body.player:
			chase()
		elif curr_state == State.CHASE:
			stop_chase()
	elif curr_state == State.CHASE:
		stop_chase()
			
func chase():
	if curr_state == State.WANDER:
		vfx_exists = true
		vfx.detected_vfx(body)
			
	raycast_timer.stop()
	curr_state = State.CHASE
	
func stop_chase():
	if raycast_timer.time_left <= 0:
		raycast_timer.start()
		
func movement(delta: float):
	if curr_state == State.WANDER:
		body.velocity = body.velocity.move_toward(direction * speed,  acceleration * delta)
	elif curr_state == State.CHASE:
		body.velocity = body.velocity.move_toward(direction * chase_speed,  acceleration * delta)
	else:
		body.velocity = body.velocity.move_toward(direction * 0,  acceleration * delta)
	
func gravity(delta: float):
	if not body.is_on_floor():
		body.velocity += body.get_gravity() * delta

func change_direction():
	# wander
	if curr_state == State.WANDER:
		# turn around if hitting wall
		if body.is_on_wall():
			animated_sprite.flip_h = not animated_sprite.flip_h
			direction *= -1
			if direction.x == 1:
				front_raycast.target_position = Vector2(front_raycast_len,0)
				rear_raycast.target_position = Vector2(-rear_raycast_len,0)
			else:
				front_raycast.target_position = Vector2(-front_raycast_len,0)
				rear_raycast.target_position = Vector2(rear_raycast_len,0)
		elif animated_sprite.flip_h:
			if body.position.x <= right_bounds.x:
				direction = Vector2(1,0)
			else:
				animated_sprite.flip_h = false
				front_raycast.target_position = Vector2(-front_raycast_len,0)
				rear_raycast.target_position = Vector2(rear_raycast_len,0)
		else:
			if body.position.x >= left_bounds.x:
				direction = Vector2(-1,0)
			else:
				animated_sprite.flip_h = true
				front_raycast.target_position = Vector2(front_raycast_len,0)
				rear_raycast.target_position = Vector2(-rear_raycast_len,0)
	# chase		
	elif curr_state == State.CHASE:
		direction = (body.player.position - body.position).normalized()
		direction = sign(direction)
		if direction.x == 1:
			animated_sprite.flip_h = true
			front_raycast.target_position = Vector2(front_raycast_len,0)
			rear_raycast.target_position = Vector2(-rear_raycast_len,0)
			
		else:
			animated_sprite.flip_h = false
			front_raycast.target_position = Vector2(-front_raycast_len,0)
			rear_raycast.target_position = Vector2(rear_raycast_len,0)


func _on_raycast_timer_timeout() -> void:
	curr_state = State.WANDER
	prev_state = State.WANDER
	
func attack() -> void:
	prev_state = curr_state
	curr_state = State.ATTACK
	tween.enemy_attack_motion(body)
	
func attack_finished() -> void:
	curr_state = prev_state
	on_cooldown = true
	await get_tree().create_timer(attack_cooldown).timeout
	on_cooldown = false
	
func _on_hit_received(hitbox: HitboxComponent) -> void:
		if curr_state not in [State.ATTACK, State.STUNNED]:
			prev_state = curr_state
		curr_state = State.STUNNED
		
		# THIS IS BAD, FIX LATER AND CONSOLIDATE HIT AND AILMENT VFX
		if hitbox.curr_atk:
			print("damage_type: ",hitbox.curr_atk.damage_type)
			# hit vfx
			if hitbox.curr_atk.damage_type == "physical":
				vfx.hit_vfx(body)
			elif hitbox.curr_atk.damage_type == "fire":
				vfx.fireball_hit_vfx(body)
			# ailment vfx
			if hitbox.curr_atk.has_ailment:
				vfx._on_ailment(body, hitbox.curr_atk)
			
		tween.knockback_motion(body, hitbox)

func restore_state() -> void:
	curr_state = prev_state
	
func vfx_state(exists: bool) -> void:
	vfx_exists = exists
