class_name Lance extends AnimatedSprite2D

@onready var animation_player: AnimationPlayer = $AnimationPlayer

const OFFSET: Vector2 = Vector2(50, 10)
var damage_event: DamageEvent = null

func _ready() -> void:
	if damage_event.spell.caster.reversed:
		set_flip_h(true)
		position = OFFSET
	animation_player.play("lance")

func _deal_damage() -> void:
	damage_event.spell.target.take_damage(damage_event)
	if damage_event.spell.caster.ai_component:
		damage_event.spell.caster.ai_component.move_ready.emit()
