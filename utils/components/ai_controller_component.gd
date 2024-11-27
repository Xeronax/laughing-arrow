class_name AIComponent extends Component
## Class for non player controlled units and their behavior

signal move_ready ## Signals that the next action in the unit's queue is ready
signal setup_done

var _enabled: bool = true
var _spellbook = null
var character: BattleCharacter = null

## Abstract function that holds the actual behavior for the unit
func turn_behavior() -> void:
	pass

## Stops turn behavior from triggering
func disable(target: BattleCharacter) -> void:
	_enabled = false
	if(target.turn_starting.is_connected(turn_behavior)):
		target.turn_starting.disconnect(turn_behavior)

## Enables turn behavior
func enable(target: BattleCharacter) -> void:
	if _enabled:
		return
	_enabled = true
	target.turn_starting.connect(turn_behavior)

## Sets variables from the target character
func _setup(target: BattleCharacter) -> void:
	character = target
	_spellbook = character.spellbook
	enable(target)
	setup_done.emit()

func _target_node_ready() -> void:
	_setup(target_node)
	print(target_node)
