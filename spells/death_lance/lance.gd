extends AnimatedSprite2D

@onready var animation_player: AnimationPlayer = $AnimationPlayer

var OFFSET: Vector2 = Vector2(50, 10)
var damage_event: DamageEvent = null

func _ready() -> void:
	if damage_event.spell.caster.reversed:
		set_flip_h(true)
	else:
		OFFSET.x *= -1
	position = OFFSET
	animation_player.play("lance")

func _deal_damage() -> void:
	print("Hitting ", damage_event.targets)
	for target in damage_event.targets:
		target.take_damage(damage_event)
	var caster: BattleCharacter = damage_event.spell.caster
	if caster.ai_component:
		caster.ai_component.move_ready.emit()
