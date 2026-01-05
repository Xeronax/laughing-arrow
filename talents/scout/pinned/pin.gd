extends Talent

var riddled_status: Status = preload("res://statuses/scout/riddled/riddled.tres")
var pinned_status: Status = preload("res://statuses/scout/pinned/pinned.tres")

func format() -> Dictionary[String, String]:
	var riddled: Status = riddled_status.duplicate()
	riddled.source = character
	var pinned: Status = pinned_status.duplicate()
	pinned.source = character
	return {
		"mp_reduction": str(pinned.mp_reduction()),
		"dodge_reduction": str(riddled.dodge_reduction()),
		"physical_resistance_reduction": str(riddled.physical_resistance_reduction())
	}
