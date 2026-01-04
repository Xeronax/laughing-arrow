extends Talent

@export var mp_reduction: int = 1
@export var dodge_reduction: int = 5

func format() -> Dictionary[String, String]:
	return {
		"mp_reduction": str(mp_reduction),
		"dodge_reduction": str(dodge_reduction)
	}
