extends Status

func evasion_reduction() -> int:
	return current_stacks * (3 * (2 + round(source.stats.mastery.final() * 0.3)))

func physical_resistance_reduction() -> int:
	return current_stacks * (3 * (1 + round(source.stats.mastery.final() * 0.1)))

func mp_reduction() -> int:
	return current_stacks * (1 + round(source.stats.mastery.final() / 30))

func format() -> Dictionary[String, String]:
	return {
		"evasion_reduction": str(evasion_reduction()),
		"physical_resistance_reduction": str(physical_resistance_reduction()),
		"mp_reduction": str(mp_reduction())
	}

func on_apply() -> void:
	super()
	resistance_changes[Global.Element.PHYSICAL] = -physical_resistance_reduction()
	skill_changes["evasion"] = -evasion_reduction()
