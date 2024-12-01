class_name DamageEvent
## Damage events are a work in progress class that implements various
## functions that streamline damage calculation

var final_damage: int ## The value that the BattleCharacter will lose as HP.
var modifiers: Array[Node]
var spell: Spell = null ## The spell being cast
var targets: Array[BattleCharacter] = []

## Constructor for damage events, takes in a spell + a damage calculation function.
func _init(caller: Spell, calc_damage: Callable = _default_damage_calculation) -> void:
	spell = caller
	modifiers = spell.get_children()
	final_damage = calc_damage.call()
	targets = spell.targeted_characters.duplicate()
	print("Got ", targets)

## If a custom damage calculation function isn't provided, this function will be used by default.
var _default_damage_calculation: Callable = func(): 
	return randi_range(spell.minimum_damage, spell.maximum_damage)
