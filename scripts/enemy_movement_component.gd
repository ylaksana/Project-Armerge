class_name EnemyMovementComponent extends Node

@export var body: CharacterBody2D
@export var animated_sprite: AnimatedSprite2D
@export var speed: float = 150.0
@export var jump = 6.0
@export var gravity_multiplier = 3.0

func tick(delta: float):
	pass
