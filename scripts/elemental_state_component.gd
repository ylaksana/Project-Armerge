class_name ElementalStateComponent extends Node

@export var hitbox: HitboxComponent
@export var elemental_cooldown_timer: Timer
@export var reaction_cooldown: float = 1.0

@export var reaction_component: ElementalReactionComponent

enum ElementState{
	NONE,
	ICE,
	FIRE,
	ELECTRIC
}

var curr_elemental_state: ElementState = ElementState.NONE

func _ready() -> void:
	hitbox.hit.connect(_on_hit)
	
