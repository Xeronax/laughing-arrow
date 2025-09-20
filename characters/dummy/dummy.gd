extends BattleCharacter

func take_damage(event: DamageEvent) -> void:
	super(event)
	var source = event.source
	if source is BattleCharacter:
		Global.gain_exp(event.final_damage)
