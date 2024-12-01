class_name AIComponent extends Component
## Class for non player controlled units and their behavior

class Threat:
	var entity: BattleCharacter
	var threat_share: int
	var spells_reachable: Dictionary

class Action:
	var method: Callable
	var required_location: Vector2i
	var score: float
	func _init(m: Callable, loc: Vector2i) -> void:
		method = m
		required_location = loc

signal move_ready ## Signals that the next action in the unit's queue is ready
signal setup_done

var _enabled: bool = true
var _spellbook = null
var character: BattleCharacter = null
var threats: Array[Threat] = []
var queue: Array[Action] = []
var possible_actions: Array[Action] = []

## Abstract function that holds the actual behavior for the unit
func turn_behavior() -> void:
	character.update_movement_range()
	print("Updating spell cells")
	_update_spell_cast_cells()
	var ac = possible_actions[0]
	ac.method.call()
	possible_actions.clear()

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
	for opponent: BattleCharacter in Global.battle_manager.player_team:
		print("Creating threat for ", opponent)
		create_threat(opponent)
	setup_done.emit()

func _target_node_ready() -> void:
	await(Global.all_ready)
	await(Global.battle_manager.participants_populated)
	_setup(target_node)

func get_target_cells(spell: Spell) -> Array[Vector2i]:
	return []

func create_threat(c: BattleCharacter) -> void:
	var t: Threat = Threat.new()
	t.entity = c
	threats.append(t)
	for threat in threats:
		threat.threat_share = roundi(100 / threats.size())

## Find the intersect between spell ranges (from targets) and movement cells
func _update_spell_cast_cells() -> void:
	for threat in threats:
		for spell: Spell in _spellbook:
			var spell_cells_from_target: Array[Vector2i] = spell.get_range_from_target(threat.entity)
			var intersect: Array[Vector2i] = spell_cells_from_target.filter(func(cell): 
				return character.movement_cells.has(cell) or cell == character.grid_position)
			if intersect.is_empty():
				continue
			for cell in intersect:
				var m: Callable = func(): 
					character.move(cell)
					await(move_ready)
					spell.targeted_cells = [threat.entity.grid_position]
					spell.targeted_characters = spell.get_characters_in_targeted_area(spell.targeted_cells)
					spell.cast()
					await(move_ready)
					character.end_turn()
				possible_actions.append(Action.new(m, cell))
