class_name SpellComponent extends Component

@export var sprite_component: SpriteComponent
@export var caster: BattleCharacter
@export var spell_icon: Texture

enum TargetType { STRAIGHT_LINE, ANY, CIRCLE, CROSS }


var animation_name: String
var spell_name: String
var ap_cost: int
var targeting_method: TargetType
var minimum_damage: int
var maximum_damage: int
var spell_range: int
var radius: int = 1
var damage_calc: Callable
var target: BattleCharacter
var _highlight_visible: bool = false

func highlight_range() -> void: 
	pass

func cast() -> bool:
	if not caster.is_turn:
		return false
	if caster.casting:
		return false
	if caster.stats.ap < ap_cost:
		print("Not enough ap to cast ", spell_name)
		return false
	caster.stats.set_ap(caster.stats.ap - ap_cost)
	return true

func deal_damage() -> void:
	target.take_damage(DamageEvent.new(self, damage_calc))
