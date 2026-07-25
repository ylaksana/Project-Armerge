extends AnimatedSprite2D


@onready var hitbox_component: HitboxComponent = $HitboxComponent
@onready var animation_player: AnimationPlayer = $AnimationPlayer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	hitbox_component.monitoring = true
	
func scorchspark() -> void:
	play("scorchspark")
	animation_finished.connect(_on_finished)
	
func scorchspark_on_floor() -> void:
	print("reaction_monitoring: ", hitbox_component.monitoring)
	print("reaction curr_atk:", hitbox_component.curr_atk)
	
	animation_player.play("ground_explosion_on_floor")
	play("scorchspark_on_floor")
	animation_finished.connect(_on_finished)

func _on_finished() -> void:
	queue_free()
	
