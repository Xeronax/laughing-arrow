class_name Spell extends Node
## Spell.gd encapsulate the default behavior of spells as an abstract class

@export var caster: BattleCharacter
@export var spell_icon: Texture

## target_selection waits for this signal
signal target_selected

## TargetType determines the cells that the spell is allowed to target, as 
## well as the geometry of the area that the spell will affect.
enum TargetType { SELF, ENEMY, ANY, ALL, CIRCLE, SQUARE, CROSS, CUSTOM }

var spell_name: String
var ap_cost: int
var targeting_method: TargetType
var minimum_damage: int
var maximum_damage: int
var spell_range: int

## Most target types have radii of 0 by default and have no behavior that cares about a radius, 
## CIRCLE, SQUARE, and CROSS need a nonzero radius defined to function 
var radius: int = 0

## Work in progress semi-placeholder for defining custom damage calculation behavior such as 
## ignoring armor, might replace with a custom class soon
var damage_calc: Callable
var target: BattleCharacter
var _highlight_visible: bool = false ## Whether or not the spell's range is being highlighted on the map.

## TODO: Puts the caster in target selection mode until they either cancel or select sufficient number of targets.
func target_selection() -> Vector2i:
	return Vector2(0,0)

## Default behavior for spells, each spell calls this as super() before going through with custom behavior.
func cast() -> bool:
	if not caster.is_turn:
		return false
	if caster.casting:
		return false
	if caster.stats.ap < ap_cost:
		print("Not enough ap to cast ", spell_name)
		return false
	target_selection()
	await(target_selected)
	caster.stats.set_ap(caster.stats.ap - ap_cost)
	caster.reversed = caster.grid_position.x > target.grid_position.x
	return true

## Creates a damage event and sends it to the target.
## This is a separate function so that it can be invoked in the AnimationPlayer.
## Spells call this as super() before other behavior that happens when a spell deals damage.
func deal_damage() -> void:
	target.take_damage(DamageEvent.new(self, damage_calc))
