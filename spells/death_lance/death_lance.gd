extends Spell

var lance_scene = preload("res://spells/death_lance/Lance.tscn")

func _ready() -> void:
	spell_name = "Death Lance"
	minimum_damage = 9
	maximum_damage = 12
	ap_cost = 5
	spell_range = 6
	target_type = TargetType.LINE

func cast() -> bool:
	if not await(super()):
		return false
	caster.sprite_component.animation_player.play("attack")
	return true

func attack() -> void:
	var damage: DamageEvent = DamageEvent.new(self, damage_calc)
	var lance: Lance = lance_scene.instantiate()
	lance.damage_event = damage
	add_child(lance)
	lance.global_position = Global.grid_to_global_position(targets[0])

func _cleanup() -> void:
	print("Cleaning")
	caster.casting = false
	caster.sprite_component.animation_player.play("idle")
