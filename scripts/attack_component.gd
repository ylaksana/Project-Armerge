class_name AttackComponent extends Node

@export var hitbox: HitboxComponent
@export var animated_sprite: AnimatedSprite2D
@export var attacks: Array[AttackData]

var curr_atk: AttackData

func _ready() -> void:
	animated_sprite.frame_changed.connect(_on_frame_changed)

func set_curr_atk(animation_name: String) -> void:
	curr_atk = null
	hitbox.monitoring = false
	#has_hit = false
	curr_atk = attacks.filter(func(atk): return atk.animation_name == animation_name).front()
	_on_frame_changed()
	print("curr_atk set to: ", curr_atk)
	
func _on_frame_changed() -> void:
	if curr_atk == null:
		return
	print("frame: ", animated_sprite.frame, " active_frames: ", curr_atk.active_frames)
	if animated_sprite.frame in curr_atk.active_frames:
		hitbox.monitoring = true
	else:
		hitbox.monitoring =  false
