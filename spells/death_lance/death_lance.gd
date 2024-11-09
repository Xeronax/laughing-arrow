extends SpellComponent


var lance_scene = preload("res://spells/death_lance/Lance.tscn")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	spell_name = "Death Lance"
	animation_name = "attack"
	target = caster.target
	minimum_damage = 9
	maximum_damage = 12
	ap_cost = 5
	spell_range = 6
	targeting_method = TargetType.ANY
	var anim

func cast() -> bool:
	if not super():
		return false
	sprite_component.animation_player.play("attack")
	return true

func attack() -> void:
	var damage: DamageEvent = DamageEvent.new(self, damage_calc)
	var lance: Lance = lance_scene.instantiate()
	lance.damage_event = damage
	target.hitbox.add_child(lance)

func _cleanup() -> void:
	print("Cleaning")
	caster.casting = false
	sprite_component.animation_player.play("idle")
