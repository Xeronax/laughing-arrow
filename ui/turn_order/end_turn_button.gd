extends Control

@onready var button: Button = $Button

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	mouse_entered.connect(func (): Global.mouse_on_ui = true)
	mouse_exited.connect(func (): Global.mouse_on_ui = false)
	await(Global.all_ready)
	Global.battle_manager.turn_starting.connect(_enable)
	button.pressed.connect(end_turn)


func _enable(current_turn_character: BattleCharacter) -> void:
	if(current_turn_character != Global.current_controller): 
		return
	print_debug("End turn button coming up!")
	button.set_disabled(false)

func end_turn() -> void:
	if Global.battle_manager.current_character != Global.current_controller:
		return
	Global.current_controller.end_turn()
	button.set_disabled(true)
