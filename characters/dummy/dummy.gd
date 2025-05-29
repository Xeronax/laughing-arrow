extends BattleCharacter

func take_damage(event: DamageEvent) -> void:
	super(event)
	var source = event.source
	if source is BattleCharacter:
		source.gain_exp(50)
