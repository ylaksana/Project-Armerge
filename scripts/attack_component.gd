class_name AttackComponent extends Node

@export var hitbox: HitboxComponent
@export var animated_sprite: AnimatedSprite2D
@export var attacks: Array[AttackData]

var is_attacking: bool = false
var is_aerial: bool = false

func _ready() -> void:
	animated_sprite.frame_changed.connect(_on_frame_changed)

func set_curr_atk(animation_name: String) -> void:
	hitbox.curr_atk = null
	hitbox.monitoring = false
	print(animation_name)
	hitbox.curr_atk = attacks.filter(func(atk): return atk.animation_name == animation_name).front()
	_on_frame_changed()
	print("curr_atk set to: ", hitbox.curr_atk)
	
func _on_frame_changed() -> void:
	if hitbox.curr_atk == null:
		return
	print("frame: ", animated_sprite.frame, " active_frames: ", hitbox.curr_atk.active_frames, ", curr_atk: ", hitbox.curr_atk)
	if animated_sprite.frame in hitbox.curr_atk.active_frames:
		hitbox.monitoring = true
	else:
		hitbox.monitoring =  false
