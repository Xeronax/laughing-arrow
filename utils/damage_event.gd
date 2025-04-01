class_name DamageEvent
## Damage events are a work in progress class that implements various
## functions that streamline damage calculation

var final_damage: int ## The value that the BattleCharacter will lose as HP.
var modifiers: Array[Node]
var spell: Spell = null ## The spell being cast
var targets: Array[BattleCharacter] = []

## Constructor for damage events, takes in a spell + a damage calculation function.
func _init(caller: Spell) -> void:
	spell = caller
	modifiers = spell.get_children()
	final_damage = caller.damage_calc.call()
	targets = spell.targeted_characters.duplicate()
