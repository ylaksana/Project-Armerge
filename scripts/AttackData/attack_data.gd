class_name AttackData extends Resource

@export var animation_name: String
@export var active_frames: Array[int]
@export var damage: float = 10.0
@export var damage_type: String
@export var attack_weight: String
@export var lunge_speed: float
@export var tween_delay: float = 0.0
@export var spawn_delay: float = 0.0

# not sure if this will be used
@export var melee: bool = true


# for special skills
@export var projectile_speed: float = 0.0
@export var projectile_duration: float = 0.0
@export var is_special_attack: bool = false
