class_name AIComponent extends Component
## Class for non player controlled units and their behavior
##
## This class is a mess

## Character along with how much the ai is inclined to attack them
class Threat:
	var entity: BattleCharacter
	var threat_share: int
	var spells_reachable: Dictionary

## Action the ai can take, most not implemented yet
class Action:
	var component: AIComponent
	var method: Callable
	var required_location: Vector2i
	var ap_cost: int = 0
	var mp_cost: int = 0
	var weight: float
	var _next: Action = null
	func _init(ai_component: AIComponent, m: Callable) -> void:
		method = m
		component = ai_component
	func run() -> void:
		method.call()
		await(component.move_ready)
		next()
	func next() -> void:
		if not _next:
			component.done.emit()
			return
		_next.run()
	func add(a: Action) -> void:
		if not _next:
			_next = a
			return
		_next.add(a)

signal move_ready ## Signals that the next action in the unit's queue is ready
signal done ## Signals that all actions are finished
signal setup_done

var _enabled: bool = true
var _spellbook = null
var character: BattleCharacter = null
var threats: Array[Threat] = [] ## Aggro table
var queue: Array[Action] = []
var possible_actions: Array[Action] = []

## Abstract function that holds the actual behavior for the unit
func turn_behavior() -> void:
	character.end_turn()
	#character.update_movement_range()
	#_update_actions()
	#possible_actions[0].run()
	#await(done)
	#character.end_turn()
	#possible_actions.clear()

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
		character.sprite_component.face_direction(opponent.grid_position)
	setup_done.emit()

func _target_node_ready() -> void:
	await(Global.all_ready)
	await(Global.battle_manager.participants_populated)
	_setup(target_node)

func create_threat(c: BattleCharacter) -> void:
	var t: Threat = Threat.new()
	t.entity = c
	threats.append(t)
	for threat in threats:
		threat.threat_share = roundi(100 / threats.size())

## Find the intersect between spell ranges (from targets) and movement cells
func _update_actions() -> void:
	possible_actions.clear()
	for threat in threats:
		for spell: Spell in _spellbook:
			var spell_cells_from_target: Array[Vector2i] = spell.get_range_from_target(threat.entity)
			print("Spell cells: ", spell_cells_from_target)
			var intersect: Array[Vector2i] = spell_cells_from_target.filter(func(cell): 
				return character.movement_cells.has(cell) or cell == character.grid_position)
			# If spell isnt in range, add an action to move closer to within range
			if intersect.is_empty():
				var min: Vector2 = spell_cells_from_target[0]
				for cell in spell_cells_from_target:
					min = cell if Global.path_to_cell(character.grid_position, cell).size() < Global.path_to_cell(character.grid_position, min).size() else min
				var closest = Global.path_to_cell(character.grid_position, min).reduce(func(max, vec):
					return vec if (vec in character.movement_cells and Global.get_dist(character.grid_position, vec) > Global.get_dist(character.grid_position, max)) else max)
				var m: Callable = func():
					character.move(closest)
					move_ready.emit()
				possible_actions.append(Action.new(self, m))
				continue
			# If the spell is in range, add an action to move to the spot where it can be cast, and then cast
			for cell in intersect:
				var move: Callable = func(): 
					character.move(cell)
					move_ready.emit()
				var cast: Callable = func():
					spell.targeted_cells = [threat.entity.grid_position]
					spell.targeted_characters = spell.get_characters_in_targeted_area(spell.targeted_cells)
					spell.cast()
					move_ready.emit()
				var a: Action = Action.new(self, move)
				a.add(Action.new(self, cast))
				possible_actions.append(a)
