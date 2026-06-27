class_name EnemyMovementComponent extends Node

# nodes
@export var body: Enemy
@export var animated_sprite: AnimatedSprite2D
@export var hurtbox: HurtboxComponent
@export var raycast_timer: Timer
@export var front_raycast: RayCast2D
@export var rear_raycast: RayCast2D
@export var front_raycast_len: float = 125
@export var rear_raycast_len: float = 10

# parameters
@export var knockback_speed: float = 150.0
@export var speed: int = 25
@export var chase_speed: int = 75
@export var jump: float = 6.0
@export var gravity_multiplier: float = 3.0
@export var acceleration: int = 300
@export var stun_duration: float = 0.5

# vfx
@export var hit_vfx: PackedScene


# enemy state
enum State{
	WANDER,
	CHASE
}

# variables
var direction: Vector2
var right_bounds: Vector2
var left_bounds: Vector2
var curr_state = State.WANDER
var is_stunned: bool = false
var knockback_tween: Tween
var rng = RandomNumberGenerator.new()
var on_rear_side : bool = true
var vfx: Node

func _ready() -> void:
	hurtbox.hit_received.connect(_on_hit_received)
	rng.randomize()
	left_bounds = body.position + Vector2(-125,0)
	right_bounds = body.position + Vector2(125,0)

func tick(delta: float):
	if body == null or body.player.health_component.curr_health <= 0 or vfx:
		body.hitbox_component.monitoring = false
		return
	
	# always affects the enemy
	gravity(delta)

	# AI resumes if not hit
	if not is_stunned:
		movement(delta)
		wander()
		change_direction()
	else:
		# AI will notice you when hit
		chase()
		body.move_and_slide()
		
	
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
		if hit_vfx:
			var body_shape: RectangleShape2D = body.get_node("body").shape as RectangleShape2D
			var position: Vector2
			if animated_sprite.flip_h: 
				position = body.get_node("body").global_position + Vector2(-body_shape.size.x/2, -body_shape.size.y)
			else:
				position = body.get_node("body").global_position + Vector2(body_shape.size.x/2, -body_shape.size.y)
			vfx = hit_vfx.instantiate()
			get_tree().root.add_child(vfx)
		
			vfx.global_position = position
			vfx.detect()

	
	raycast_timer.stop()
	curr_state = State.CHASE
	
func stop_chase():
	if raycast_timer.time_left <= 0:
		raycast_timer.start()
		
func movement(delta: float):
	if curr_state == State.WANDER:
		body.velocity = body.velocity.move_toward(direction * speed,  acceleration * delta)
	else:
		body.velocity = body.velocity.move_toward(direction * chase_speed,  acceleration * delta)
	
	body.move_and_slide()
	
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
	else:
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
	
	
func _on_hit_received(hitbox: HitboxComponent, right_hit: bool) -> void:
		#print("hurt")
		is_stunned = true
		if hit_vfx:
			var position = body.get_node("body").global_position
			var hurt_vfx = hit_vfx.instantiate()
			get_tree().root.add_child(hurt_vfx)
			hurt_vfx.global_position = position
			hurt_vfx.hit()
			
		if hitbox.curr_atk:
			var hit_direction = -1 if right_hit else 1
			if knockback_tween:
				knockback_tween.kill()
			knockback_tween = create_tween()
			# knockback
			if hitbox.curr_atk.attack_weight == "light":
				print("attack weight = ",hitbox.curr_atk.attack_weight)
				var random_multiplier = rng.randf_range(0.5,1.6)
				knockback_tween.tween_property(body, "velocity:x", knockback_speed * random_multiplier * hit_direction, 0.05).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
				knockback_tween.tween_property(body, "velocity:x", 0.0, 0.01).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN)
			elif hitbox.curr_atk.attack_weight == "medium":
				print("attack weight = ",hitbox.curr_atk.attack_weight)
				var random_multiplier = rng.randf_range(1.7, 2.5)
				knockback_tween.tween_property(body, "velocity:x", knockback_speed * random_multiplier * hit_direction, 0.05).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
				knockback_tween.tween_property(body, "velocity:x", 0.0, 0.01).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN)
			elif hitbox.curr_atk.attack_weight == "heavy":
				print("attack weight = ",hitbox.curr_atk.attack_weight)
				var random_multiplier = rng.randf_range(2.8,3.5)
				knockback_tween.tween_property(body, "velocity:x", knockback_speed * random_multiplier * hit_direction, 0.1).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
				knockback_tween.parallel().tween_property(body, "velocity:y", -speed * 0.5, 0.01).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
				knockback_tween.tween_property(body, "velocity:x", 0.0, 0.05).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN)
			knockback_tween.tween_interval(stun_duration)
			knockback_tween.finished.connect(can_move)

func can_move() -> void:
	is_stunned = false
