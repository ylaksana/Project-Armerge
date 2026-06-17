class_name HitboxComponent extends Area2D

signal hit(hurtbox)

@export var is_player: bool = true
@export var movement_component : MovementComponent
@export var animated_sprite: AnimatedSprite2D
@export var body: CharacterBody2D
@export var body_collision: CollisionShape2D

var damage = 5
var hitbox_shape: CollisionShape2D
var hitbox_position: float
var hitbox_offset: float
var collision_position : float

func _ready() -> void:
	#print("I am: ", get_parent().name, " hitbox layer: ", collision_layer, " mask: ", collision_mask)
	monitoring = false
	if is_player:
		hitbox_shape = self.get_node("CollisionShape2D")
		collision_position = body_collision.position.x
		#print("hitbox_position before: ",hitbox_position)
		var collision_diameter = (body_collision.shape as RectangleShape2D).size.x
		var hitbox_diameter = (hitbox_shape.shape as RectangleShape2D).size.x
		#print("hitbox_diameter: ",hitbox_diameter)
		#print("collision_diameter: ",collision_diameter)
		
		# set the offset for the hitbox
		hitbox_offset = (ceil(collision_diameter/2) + ceil(hitbox_diameter/2))
		#print(hitbox.get_parent().name)
		# load the hitbox in front of where the player is facing
		if animated_sprite.flip_h == false:
			hitbox_position = body_collision.position.x - hitbox_offset
		else:
			hitbox_position = body_collision.position.x + hitbox_offset
		
		#print("hitbox_offset: ",hitbox_offset)
		#print("hitbox_position after: ", hitbox_position)
		monitoring = false
		collision_layer = 1
		collision_mask = 8
	else:
		print("enemy body layer: ", collision_layer, " mask: ", collision_mask)
		monitoring = true
		collision_layer = 4
		collision_mask = 2
	area_entered.connect(_on_area_entered)
	
func tick(delta: float) -> void:
	if body == null:
		return
		
	if movement_component.dir < 0.0:
		if is_player:
			# change the hitbox to face where the player is facing while hugging the overall collision shape
			hitbox_shape.position.x = collision_position - hitbox_offset
			#print(hitbox_shape.position.x)
	
	# move right
	elif movement_component.dir > 0.0:
		if is_player:
			# change the hitbox to face where the player is facing while hugging the overall collision shape
			hitbox_shape.position.x = collision_position + hitbox_offset
			#print(hitbox_shape.position.x)

func _on_area_entered(area):
	if area is HurtboxComponent:
		#monitoring = true
		area.take_hit(self)
		hit.emit(area)
