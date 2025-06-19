extends Spell

func cast() -> bool:
	if not await(super()):
		return false
	var cell: Vector2 = targeted_cells[0]
	caster.sprite_component.Sprite.pause()
	caster.sprite_component.Sprite.set_animation("run")
	caster.sprite_component.Sprite.set_frame(1)
	caster.sprite_component.animation_player.pause()
	var tween: Tween = caster.get_tree().get_root().create_tween()
	tween.tween_property(caster, "global_position", Global.grid_to_global_position(cell), 0.4).set_ease(Tween.EASE_OUT)
	tween.tween_callback(func(): 
		caster.set_grid_position(cell)
		caster.sprite_component.animation_player.play("idle")
		caster.state = BattleCharacter.States.IDLE)
	_cleanup()
	return true
