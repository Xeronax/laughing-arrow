class_name Stats extends Component
## StatComponent implements component behavior to represent stats

class Stat:
	var base: float = 0
	var flat_bonus: float = 0
	var max: float = 1
	var current: float = 0 # Only for stats that are resources
	var percent_bonus: float = 0
	signal changed
	func _init(base_init: Variant) -> void:
		base = base_init
		max = base_init
	func final() -> Variant:
		if base < 1 and base > 0:
			return float((base + flat_bonus) * (1 + percent_bonus))
		else:
			return int(round((base + flat_bonus) * (1 + percent_bonus)))
	func add_flat(value: int) -> void:
		flat_bonus += value
		changed.emit()
	func add_percent(value: float) -> void:
		percent_bonus += value
		changed.emit()
	func set_current(value: Variant) -> void:
		current = value
		changed.emit()

@export var base_hp: int = 50
@export var base_ap: int = 4
@export var base_mp: int = 3
@export var base_strength: int = 10
@export var base_intelligence: int = 10
@export var base_dexterity: int = 10
@export var base_constitution: int = 10
@export var base_mastery: int = 0
@export var base_critical_strike_chance: float = 0.05
@export var base_critical_strike_damage: float = 2.0
@export var base_block_chance: float = 0.0
@export var base_block_damage_reduction: float = 0.0
@export var base_dodge_chance: float = 0.05
@export var base_presence: int = 0
@export var base_range: int = 0
@export var base_piety: int = 0
@export var base_initiative: int = 0
@export var base_damage: Dictionary = {
	"Physical": 0,
	"Arcane": 0,
	"Fire": 0,
	"Water": 0,
	"Earth": 0,
	"Wind": 0,
	"Holy": 0,
	"Void": 0
}
@export var base_resistances: Dictionary = {
	"Physical": 0,
	"Arcane": 0,
	"Fire": 0,
	"Water": 0,
	"Earth": 0,
	"Wind": 0,
	"Holy": 0,
	"Void": 0
}

var damage: Dictionary[int, Stat] = {
	Global.Element.PHYSICAL: Stat.new(base_damage.get("Physical")),
	Global.Element.ARCANE: Stat.new(base_damage.get("Arcane")),
	Global.Element.FIRE: Stat.new(base_damage.get("Fire")),
	Global.Element.WATER: Stat.new(base_damage.get("Water")), 
	Global.Element.EARTH: Stat.new(base_damage.get("Earth")), 
	Global.Element.WIND: Stat.new(base_damage.get("Wind")), 
	Global.Element.HOLY: Stat.new(base_damage.get("Holy")), 
	Global.Element.VOID: Stat.new(base_damage.get("Void"))
}
var resistances: Dictionary[int, Stat] = {
	Global.Element.PHYSICAL: Stat.new(base_resistances.get("Physical")),
	Global.Element.ARCANE: Stat.new(base_resistances.get("Arcane")),
	Global.Element.FIRE: Stat.new(base_resistances.get("Fire")),
	Global.Element.WATER: Stat.new(base_resistances.get("Water")), 
	Global.Element.EARTH: Stat.new(base_resistances.get("Earth")), 
	Global.Element.WIND: Stat.new(base_resistances.get("Wind")), 
	Global.Element.HOLY: Stat.new(base_resistances.get("Holy")), 
	Global.Element.VOID: Stat.new(base_resistances.get("Void"))
}

var hp: Stat
var ap: Stat
var mp: Stat

var strength: Stat
var intelligence: Stat
var dexterity: Stat
var constitution: Stat
var mastery: Stat

var critical_strike_chance: Stat
var critical_strike_damage: Stat
var block_chance: Stat
var block_damage_reduction: Stat
var dodge_chance: Stat
var presence: Stat
var range: Stat
var piety: Stat
var initiative: Stat
## The Battle Manager starts each battle by creating a turn order that's
## determined by each BattleCharacter's initiative.

func setup() -> void:
	hp = Stat.new(base_hp)
	mp = Stat.new(base_mp)
	ap = Stat.new(base_ap)
	strength = Stat.new(base_strength)
	intelligence = Stat.new(base_intelligence)
	dexterity = Stat.new(base_dexterity)
	constitution = Stat.new(base_constitution)
	mastery = Stat.new(base_mastery)
	critical_strike_chance = Stat.new(base_critical_strike_chance)
	critical_strike_damage = Stat.new(base_critical_strike_damage)
	block_chance = Stat.new(base_block_chance)
	block_damage_reduction = Stat.new(base_block_damage_reduction)
	dodge_chance = Stat.new(base_dodge_chance)
	presence = Stat.new(base_presence)
	range = Stat.new(base_range)
	piety = Stat.new(base_piety)
	initiative = Stat.new(base_initiative)

func update() -> void:
	for stat: Stat in [hp, ap, mp]:
		stat.max = stat.final()

func _ready() -> void:
	setup()
