class_name Spell extends Resource
## Spell.gd encapsulate the default behavior of spells as an abstract class

@export var spell_icon: Texture
@export var spell_name: String
@export var ap_cost: int = 0
@export var mp_cost: int = 0
@export var minimum_damage: int
@export var maximum_damage: int
@export var spell_range: int
@export var cooldown: int = 1
@export_multiline var description: String

var caster: BattleCharacter

var current_cooldown: int = 0

signal casted
signal cooldown_ticked

## TargetType determines the cells that the spell is allowed to target
enum TargetType { SELF, FREE_CELL, ENEMY, ANY, ALL, LINE }
## The enums are connected to the targeting method Callables through this Dictionary
@export var target_type: TargetType
var targeting_method: Dictionary = {
	TargetType.ENEMY : target_enemy,
	TargetType.LINE : target_line,
	TargetType.FREE_CELL : target_cell,
}

## AreaOfEffect determines the geometry of the area that the spell will affect.
enum AreaOfEffect { NONE, LINE, CIRCLE, SQUARE, CROSS, CUSTOM }
var area_of_effect: AreaOfEffect

## Most target types have radii of 0 by default and have no behavior that cares about a radius, 
## CIRCLE, SQUARE, CROSS, and LINE need a nonzero radius defined to function 
var radius: int = 0

## Work in progress semi-placeholder for defining custom damage calculation behavior such as 
## ignoring armor, might replace with a custom class soon
var damage_calc: Callable = func():
	return randi_range(minimum_damage, maximum_damage)
var targeted_cells: Array[Vector2i] = []
var targeted_characters: Array[BattleCharacter] = []

func _init() -> void:
	await Global.all_ready
	Global.battle_manager.turn_starting.connect(func(character: BattleCharacter):
		if character != caster:
			return
		if current_cooldown <= 0:
			return
		tick_cooldown())

## Default behavior for spells, each spell calls this as super() before going through with custom behavior.
## Should be called as a conditional and cancel custom behavior if super() returns false
func cast() -> bool:
	## If it's not the caster's turn, cancel
	if not caster.is_turn:
		_cleanup()
		return false
	## If the caster is casting already, moving, or dead, cancel
	if caster.state in [BattleCharacter.States.CASTING, BattleCharacter.States.MOVING, BattleCharacter.States.DEAD]:
		_cleanup()
		return false
	## If the caster doesn't have enough AP to cast the spell, cancel
	if caster.stats.ap.current < ap_cost or caster.stats.mp.current < mp_cost:
		print("Not enough AP or MP to cast ", spell_name)
		_cleanup()
		return false
	if current_cooldown > 0:
		print("Spell is on cooldown")
		_cleanup()
		return false
	caster.state = BattleCharacter.States.TARGETING
	## If the caster doesn't select appropriate and/or enough targets, cancel
	if not await targeting_method[target_type].call():
		caster.state = BattleCharacter.States.IDLE
		_cleanup()
		# print_debug("Targeted cells array: ", targeted_cells)
		return false
	caster.stats.ap.set_current(caster.stats.ap.current - ap_cost)
	caster.stats.mp.set_current(caster.stats.mp.current - mp_cost)
	caster.reversed = caster.grid_position.x > targeted_cells[0].x
	caster.spell_cells.clear()
	caster.state = BattleCharacter.States.CASTING
	casted.emit()
	tick_cooldown()
	return true ## Approve the spell cast and proceed with custom behavior

## Creates a damage event and sends it to the target.
## This is a separate function so that it can be invoked in the AnimationPlayer.
## Spells call this as super() before other behavior that happens when a spell deals damage.
func deal_damage() -> void:
	for target in targeted_characters:
		target.take_damage(DamageEvent.new(self))

func get_range_from_target(t: BattleCharacter) -> Array[Vector2i]:
	var range: Array[Vector2i] = []
	match target_type:
		TargetType.ENEMY:
			range = Global.get_range(t.grid_position, spell_range)
		TargetType.LINE:
			range = Global.get_range(t.grid_position, spell_range).filter(func(cell):
				return (cell.x == t.grid_position.x or cell.y == t.grid_position.y)) 
	return range

func get_range() -> Array[Vector2i]:
	var range: Array[Vector2i] = []
	match target_type:
		TargetType.ENEMY:
			range = Global.get_range(caster.grid_position, spell_range)
		TargetType.LINE:
			range = Global.get_range(caster.grid_position, spell_range).filter(func(cell):
				return (cell.x == caster.grid_position.x or cell.y == caster.grid_position.y))
	return range

### Targeting methods
func target_enemy() -> bool:
	Global.highlight_map.clear()
	caster.spell_cells = Global.get_range(caster.grid_position, spell_range)
	for cell in caster.spell_cells:
		Global.highlight_cell(cell, Global.ORANGE)
	var temp = await Global.target_selected
	# print_debug("Signal: ", temp)
	for cell in temp:
		targeted_cells.append(cell)
	targeted_characters = get_characters_in_targeted_area(targeted_cells)
	# print_debug("Targeted characters: ", targeted_characters)
	return not targeted_characters.is_empty()

func target_line() -> bool:
	if caster.ai_component:
		return true
	return false

func target_cell() -> bool:
	Global.highlight_map.clear()
	caster.spell_cells = Global.get_range(caster.grid_position, spell_range)
	for cell in caster.spell_cells:
		Global.highlight_cell(cell, Global.ORANGE)
	for cell in await Global.target_selected:
		if not caster.spell_cells.has(cell):
			continue
		targeted_cells.append(cell)
	return not targeted_cells.is_empty()

func get_characters_in_targeted_area(_area: Array[Vector2i]) -> Array[BattleCharacter]:
	var temp: Array[BattleCharacter] = []
	var chars: Array[BattleCharacter] = targeted_cells.reduce(func(acc, cell): 
		var character = Global.get_character(cell)
		if character != null:
			# print_debug("Got character ", character, " for cell ", cell)
			acc.append(character)
		return acc
	, temp)
	return chars

func tick_cooldown() -> void:
	if current_cooldown <= 0:
		current_cooldown = cooldown
	else:
		current_cooldown -= 1
	cooldown_ticked.emit()

func _cleanup() -> void:
	targeted_cells.clear()
	targeted_characters.clear()
