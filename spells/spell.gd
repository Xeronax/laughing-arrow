class_name Spell extends Node
## Spell.gd encapsulate the default behavior of spells as an abstract class

@export var caster: BattleCharacter
@export var spell_icon: Texture

## TargetType determines the cells that the spell is allowed to target, as 
## well as the geometry of the area that the spell will affect.
enum TargetType { SELF, ENEMY, ANY, ALL, LINE, CIRCLE, SQUARE, CROSS, CUSTOM }

var spell_name: String
var target_type: TargetType
var ap_cost: int
var minimum_damage: int
var maximum_damage: int
var spell_range: int

## Most target types have radii of 0 by default and have no behavior that cares about a radius, 
## CIRCLE, SQUARE, CROSS, and LINE need a nonzero radius defined to function 
var radius: int = 0

## Work in progress semi-placeholder for defining custom damage calculation behavior such as 
## ignoring armor, might replace with a custom class soon
var damage_calc: Callable
var targets: Array[Vector2i] = []
var targeted_characters: Array[BattleCharacter]
var _highlight_visible: bool = false ## Whether or not the spell's range is being highlighted on the map.
var targeting_method: Dictionary = {
	TargetType.ENEMY : target_enemy,
	TargetType.LINE : target_line
}

## Default behavior for spells, each spell calls this as super() before going through with custom behavior.
## Should be called as a conditional and cancel custom behavior if super() returns false
func cast() -> bool:
	## If it's not the caster's turn, cancel
	if not caster.is_turn:
		return false
	## If the caster is casting already, moving, or dead, cancel
	if caster.state in [BattleCharacter.States.CASTING, BattleCharacter.States.MOVING, BattleCharacter.States.DEAD]:
		return false
	## If the caster doesn't have enough AP to cast the spell, cancel
	if caster.stats.ap < ap_cost:
		print("Not enough ap to cast ", spell_name)
		return false
	caster.state = BattleCharacter.States.TARGETING
	## If the caster doesn't select appropriate and/or enough targets, cancel
	if not await targeting_method[target_type].call():
		caster.state = BattleCharacter.States.IDLE
		return false
	caster.stats.set_ap(caster.stats.ap - ap_cost)
	caster.reversed = caster.grid_position.x > targeted_characters[0].grid_position.x
	caster.spell_cells.clear()
	caster.state = BattleCharacter.States.CASTING
	return true ## Approve the spell cast and proceed with custom behavior

## Creates a damage event and sends it to the target.
## This is a separate function so that it can be invoked in the AnimationPlayer.
## Spells call this as super() before other behavior that happens when a spell deals damage.
func deal_damage() -> void:
	for target in targeted_characters:
		target.take_damage(DamageEvent.new(self))

### Targeting methods
func target_enemy() -> bool:
	Global.highlight_map.clear()
	caster.spell_cells = Global.get_range(caster.grid_position, spell_range)
	for cell in caster.spell_cells:
		Global.highlight_cell(cell, Global.ORANGE)
	for cell in await Global.target_selected:
		targets.append(cell)
	var temp: Array[BattleCharacter] = []
	targeted_characters = targets.reduce(func(acc, cell): 
		var character = Global.get_character(cell)
		if character != null:
			acc.append(character)
		return acc
	, temp)
	return not targeted_characters.is_empty()

func target_line() -> bool:
	return true
