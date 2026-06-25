class_name EnemyMovementComponent extends Node

# nodes
@export var body: Enemy
@export var animated_sprite: AnimatedSprite2D
@export var enemy_animation_component: EnemyAnimationComponent
@export var hurtbox: HurtboxComponent
@export var raycast: RayCast2D
@export var raycast_timer: Timer
#@export var detection_component: DetectionComponent

# parameters
@export var knockback_speed: float = 150.0
@export var speed: int = 50
@export var chase_speed: int = 150
@export var jump: float = 6.0
@export var gravity_multiplier: float = 3.0
@export var acceleration: int = 300

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
var is_hit: bool = false

func _ready() -> void:
	hurtbox.hit_received.connect(_on_hit_received)
	left_bounds = body.position + Vector2(-125,0)
	right_bounds = body.position + Vector2(125,0)
	#detection_component.detect.connect(_on_detect)

func tick(delta: float):
	if body == null:
		return
	
	if not is_hit:
		movement(delta)
		gravity(delta)
		wander()
		change_direction()
	
func wander():
	if raycast.is_colliding():
		var collider = raycast.get_collider()
		if collider == body.player:
			chase()
		elif curr_state == State.CHASE:
			stop_chase()
	elif curr_state == State.CHASE:
		stop_chase()
			
func chase():
	raycast_timer.stop()
	curr_state = State.CHASE
	
func stop_chase():
	if raycast_timer.time_left <= 0:
		raycast_timer.start()
		
func movement(delta: float):
	if curr_state == State.WANDER:
		body.velocity = body.velocity.move_toward(direction * speed * 0.5,  acceleration * delta)
	else:
		body.velocity = body.velocity.move_toward(direction * speed * 0.5,  acceleration * delta)
	
	body.move_and_slide()
	
func gravity(delta: float):
	if not body.is_on_floor():
		body.velocity += body.get_gravity() * delta

func change_direction():
	# wander
	if curr_state == State.WANDER:
		if animated_sprite.flip_h:
			if body.position.x <= right_bounds.x:
				direction = Vector2(-1,0)
			else:
				animated_sprite.flip_h = false
				raycast.target_position = Vector2(-125,0)
		else:
			if body.position.x >= left_bounds.x:
				direction = Vector2(1,0)
			else:
				animated_sprite.flip_h = true
				raycast.target_position = Vector2(125,0)
	# chase		
	else:
		direction = (body.player.position - body.position).normalized()
		direction = sign(direction)
	if direction.x == 1:
		animated_sprite.flip_h = true
		raycast.target_position = Vector2(125,0)
	else:
		animated_sprite.flip_h = false
		raycast.target_position = Vector2(-125,0)


func _on_raycast_timer_timeout() -> void:
	curr_state = State.WANDER
	
	
func _on_hit_received(hitbox: HitboxComponent, right_hit: bool) -> void:
		#print("hurt")
		is_hit = false
		if hit_vfx:
			var position = hurtbox.global_position
			var vfx = hit_vfx.instantiate()
			get_tree().root.add_child(vfx)
			vfx.global_position = position
			
		var hit_direction = -1 if right_hit else 1
		var tween = create_tween()
		
		# knockback
		if hitbox.curr_atk.attack_weight == "light":
			tween.tween_property(body, "velocity:x", knockback_speed * hit_direction, 0.05).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
			tween.tween_property(body, "velocity:x", 0.0, 0.01).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN)
		elif hitbox.curr_atk.attack_weight == "medium":
			print(hitbox.curr_atk.attack_weight)
			tween.tween_property(body, "velocity:x", knockback_speed * 1.5 * hit_direction, 0.05).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
			tween.tween_property(body, "velocity:x", 0.0, 0.01).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN)
		elif hitbox.curr_atk.attack_weight == "heavy":
			print(hitbox.curr_atk.attack_weight)
			tween.tween_property(body, "velocity:x", knockback_speed * 2 * hit_direction, 0.1).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
			tween.parallel().tween_property(body, "velocity:y", -speed * 0.5, 0.01).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
			tween.tween_property(body, "velocity:x", 0.0, 0.05).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN)
