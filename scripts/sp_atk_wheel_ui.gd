extends Node

@onready var selection_wheel: Control = $UI/SelectionWheel
@onready var equip: Label = $UI/equip

var toggle_pressed: bool
var toggle_released: bool

func _ready() -> void:
	selection_wheel.hide()

func tick(delta: float) -> void:
	if toggle_pressed:
		selection_wheel.show()
	elif toggle_released:
		var special_attack = selection_wheel.Close()
		selection_wheel.Close()
		equip.text = "Player equipped special attack: " + special_attack
