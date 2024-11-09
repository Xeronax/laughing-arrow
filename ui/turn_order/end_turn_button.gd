extends Control

@onready var button: Button = $Button
@export var target: BattleCharacter

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	button.pressed.connect(target.end_turn)
	target.turn_starting.connect(_enable)
	pass # Replace with function body.

func _enable() -> void:
	button.set_disabled(false)

func _focus_target(character: BattleCharacter) -> void:
	target.turn_starting.disconnect(_enable)
	target = character
	target.turn_starting.connect(_enable)
