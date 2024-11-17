extends Control

@onready var button: Button = $Button
@export var target: BattleCharacter

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	mouse_entered.connect(func (): Global.mouse_on_ui = true)
	mouse_exited.connect(func (): Global.mouse_on_ui = false)
	_focus_target(target)

func _enable() -> void:
	button.set_disabled(false)

func _disable() -> void:
	button.set_disabled(true)

func _focus_target(character: BattleCharacter) -> void:
	if target.turn_starting.is_connected(_enable):
		target.turn_starting.disconnect(_enable)
	target = character
	button.pressed.connect(target.end_turn)
	target.turn_starting.connect(_enable)
	target.turn_ending.connect(_disable)
