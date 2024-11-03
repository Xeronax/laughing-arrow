class_name SpellComponent extends Component

@export var sprite_component: SpriteComponent
@export var character: BattleCharacter
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
	if not character.is_turn:
		return false
	if character.casting:
		return false
	if character.stats.ap < ap_cost:
		print("Not enough ap to cast ", spell_name)
		return false
	character.stats.ap -= ap_cost
	character.stats.ap_changed.emit(character.stats.ap)
	return true

func deal_damage() -> void:
	target.take_damage(DamageEvent.new(self, damage_calc))
	target.sprite_component.Sprite.play("get_hit")
