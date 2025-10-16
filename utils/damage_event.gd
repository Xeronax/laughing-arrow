class_name DamageEvent
## Damage events are a work in progress class that implements various
## functions that streamline damage calculation

var final_damage: int ## The value that the BattleCharacter will lose as HP.
var modifiers: Array[Node]
var spell: Spell = null ## The spell being cast
var targets: Array[BattleCharacter] = []
var source: BattleCharacter
var critical_strike: bool = false

## Constructor for damage events, takes in a spell + a damage calculation function.
func _init(caller: Spell) -> void:
	source = caller.caster
	spell = caller
	#modifiers = spell.get_children()
	final_damage = caller.damage_calc.call()
	_critical_strike()
	targets = spell.targeted_characters.duplicate()


func _critical_strike(force: bool = false) -> void:
	var roll: float = randf()
	var crit_chance: float = source.stats.critical_strike_chance.final()
	var crit_damage: float = source.stats.critical_strike_damage.final()
	print_debug("Rolled ", roll * 100, "/", 1 - (crit_chance * 100))
	if(roll > 1 - crit_chance || force):
		critical_strike = true
		final_damage *= 1 + crit_damage
