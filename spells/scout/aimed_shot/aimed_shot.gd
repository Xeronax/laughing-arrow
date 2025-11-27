extends Spell

func cast() -> bool:
	if not await(super()):
		return false
	caster.state = BattleCharacter.States.CASTING
	caster.sprite_component.animation_player.play("attack")
	#var damage_delay: Timer = Timer.new()
	#caster.add_child(damage_delay)
	#damage_delay.start(1)
	await(caster.sprite_component.hit_frame)
	deal_damage()
	#damage_delay.queue_free()
	return true

func deal_damage() -> void:
	super()
	caster.state = BattleCharacter.States.IDLE
	caster.sprite_component.animation_player.play("idle")
	print("Targeted chars: ", targeted_characters)
	for target: BattleCharacter in targeted_characters:
		target.sprite_component.animation_player.play("get_hit")
	_cleanup()
