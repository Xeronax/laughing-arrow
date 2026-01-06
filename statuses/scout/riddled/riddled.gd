extends Status

var pinned: Status = preload("res://statuses/scout/pinned/pinned.tres")

func dodge_reduction() -> int:
	print_debug("Calculating dodge reduction for status: ", self, ", current stacks are: ", current_stacks)
	return current_stacks * (2 + round(source.stats.mastery.final() * 0.3))

func physical_resistance_reduction() -> int:
	return current_stacks * (1 + round(source.stats.mastery.final() * 0.1))

func format() -> Dictionary[String, String]:
	return {
		"dodge_reduction": str(dodge_reduction()),
		"physical_resistance_reduction": str(physical_resistance_reduction())
	}

func on_apply() -> void:
	super()
	resistance_changes.physical = -physical_resistance_reduction()
	skill_changes.dodge = -dodge_reduction()
	if current_stacks > 2:
		target.remove_status(self)
		var new_pin: Status = pinned.duplicate()
		new_pin.source = source
		target.apply_status(new_pin)
