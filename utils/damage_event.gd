class_name DamageEvent

var final_damage: int
var modifiers: Array[Node]
var spell: SpellComponent = null

func _init(caller: SpellComponent, calc_damage: Callable) -> void:
	spell = caller
	modifiers = spell.get_children()
	if(calc_damage):
		final_damage = calc_damage.call()
		return
	var base_damage: int = randi_range(spell.minimum_damage, spell.maximum_damage)
	final_damage = base_damage
