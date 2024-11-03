extends SpellComponent


const OFFSET: Vector2 = Vector2(50, 0)

var lance: AnimatedSprite2D = null

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	spell_name = "Death Lance"
	animation_name = "attack"
	target = character.target
	minimum_damage = 9
	maximum_damage = 12
	ap_cost = 5
	spell_range = 6
	targeting_method = TargetType.ANY
	var anim

func cast() -> bool:
	if not super():
		return false
	character.casting = true
	sprite_component.Sprite.play(animation_name)
	sprite_component.Sprite.frame_changed.connect(_attack) # Triggers the spell effect to happen on the 34th frame
	sprite_component.Sprite.animation_finished.connect(_cleanup)
	return true

func _attack() -> void:
	if(sprite_component.Sprite.get_frame() != 34):
		return
	lance = preload("res://spells/death_lance/Lance.tscn").instantiate()
	target.add_child(lance)
	lance.set_visible(true)
	print(lance.global_position)
	if(character.reversed):
		lance.set_global_position(target.sprite_component.Sprite.global_position)
		lance.set_flip_h(true)
		lance.play()
	else:
		lance.set_global_position(target.global_position)
		lance.set_flip_h(false)
		lance.play()
	lance.frame_changed.connect(_animation_deal_damage)
	lance.animation_finished.connect(_cleanup_spell_effect)
	if(character.ai_component):
		character.ai_component.move_ready.emit()

func _cleanup() -> void:
	print("Cleaning")
	character.casting = false
	sprite_component.Sprite.pause()
	sprite_component.animate()
	sprite_component.Sprite.animation_finished.disconnect(_cleanup)

func _cleanup_spell_effect() -> void:
	print("Cleaning up animation")
	lance.animation_changed.disconnect(_animation_deal_damage)
	lance.queue_free()
	target.sprite_component.animate()
	sprite_component.Sprite.frame_changed.disconnect(_attack)
	character.ai_component.move_ready.emit()
	lance = null

func _animation_deal_damage() -> void:
	if(sprite_component.Sprite.get_frame() != 6):
		return
	deal_damage()
