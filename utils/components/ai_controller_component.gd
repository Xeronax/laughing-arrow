class_name AIComponent extends Component

signal move_ready
signal setup_done

var _enabled: bool = true
var _spellbook = null
var character: BattleCharacter = null

func turn_behavior() -> void:
	pass

func disable(target: BattleCharacter) -> void:
	_enabled = false
	if(target.turn_starting.is_connected(turn_behavior)):
		target.turn_starting.disconnect(turn_behavior)

func enable(target: BattleCharacter) -> void:
	if _enabled:
		return
	_enabled = true
	target.turn_starting.connect(turn_behavior)

func _setup(target: BattleCharacter) -> void:
	print("Target: ", target)
	character = target
	print("Character: ", character)
	_spellbook = character.spellbook
	print("Spellbook: ", character.spellbook)
	enable(target)
	setup_done.emit()

func _target_node_ready() -> void:
	_setup(target_node)
