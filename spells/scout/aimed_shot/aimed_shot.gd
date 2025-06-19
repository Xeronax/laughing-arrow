extends Spell

func cast() -> bool:
	if not await(super()):
		return false
	caster.state = BattleCharacter.States.CASTING
	caster.sprite_component.animation_player.play("attack")
	return true

func deal_damage() -> void:
	super()
	caster.state = BattleCharacter.States.IDLE
	caster.sprite_component.animation_player.play("idle")
	for target: BattleCharacter in targeted_characters:
		target.sprite_component.animation_player.play("get_hit")
	_cleanup()
