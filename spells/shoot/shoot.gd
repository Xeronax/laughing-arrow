extends SpellComponent

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	spell_name = "Shoot"
	animation_name = "attack"
	ap_cost = 2
	targeting_method = TargetType.ANY
	spell_range = 7
	minimum_damage = 3
	maximum_damage = 5

func cast() -> bool:
	if not super():
		return false
	caster.casting = true
	caster.sprite_component.Sprite.play(animation_name)
	caster.sprite_component.Sprite.frame_changed.connect(attack)
	caster.sprite_component.Sprite.animation_finished.connect(_cleanup)
	return true

func attack() -> void:
	if(caster.sprite_component.Sprite.get_frame() != 8):
		return
	deal_damage()

func _cleanup() -> void:
	caster.casting = false
	caster.sprite_component.Sprite.frame_changed.disconnect(attack)
	caster.sprite_component.Sprite.animation_finished.disconnect(_cleanup)
