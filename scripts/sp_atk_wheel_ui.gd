extends Node

@export var body: Player
@onready var selection_wheel: Control = $UI/SelectionWheel
@onready var equip: Label = $UI/equip

var toggle_pressed: bool
var toggle_released: bool

func _ready() -> void:
	selection_wheel.hide()

func tick(delta: float) -> void:
	if toggle_pressed:
		print("showing wheel")
		selection_wheel.show()
	elif toggle_released:
		var special_attack_name = selection_wheel.Close()
		print(special_attack_name)
		body.special_attack_component.set_special_attack(special_attack_name)
		equip.text = "Player equipped special attack: " + special_attack_name
