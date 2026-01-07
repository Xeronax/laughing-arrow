class_name Stats extends Component
## StatComponent implements component behavior to represent stats

class Stat:
	var base: float = 0
	var flat_bonus: float = 0
	var max: float = 1
	var current: float = 0 # Only for stats that are resources
	signal changed
	func _init(base_init: Variant) -> void:
		base = base_init
		max = base_init
		
	func final() -> Variant:
		if base < 1 and base > 0:
			return float((base + flat_bonus))
		else:
			return int(round((base + flat_bonus)))
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
@export var base_evasion: float = 0.05
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
var evasion: Stat
var presence: Stat
var range: Stat
var piety: Stat
var initiative: Stat
## The Battle Manager starts each battle by creating a turn order that's
## determined by each BattleCharacter's initiative.

func get_all_stats() -> Array[Stat]:
	return [hp, ap, mp, strength, intelligence, dexterity, constitution, mastery,
	critical_strike_chance, critical_strike_damage, block_chance, block_damage_reduction,
	evasion, presence, range, piety, initiative]

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
	evasion = Stat.new(base_evasion)
	presence = Stat.new(base_presence)
	range = Stat.new(base_range)
	piety = Stat.new(base_piety)
	initiative = Stat.new(base_initiative)


func update() -> void:
	var character: BattleCharacter = target_node
	var damage_bonuses: Dictionary[int, float] = {
		Global.Element.PHYSICAL: 0,
		Global.Element.ARCANE: 0,
		Global.Element.FIRE: 0,
		Global.Element.WATER: 0,
		Global.Element.EARTH: 0,
		Global.Element.WIND: 0,
		Global.Element.HOLY: 0,
		Global.Element.VOID: 0,
	}
	var resistance_bonuses: Dictionary[int, float] = {
		Global.Element.PHYSICAL: 0,
		Global.Element.ARCANE: 0,
		Global.Element.FIRE: 0,
		Global.Element.WATER: 0,
		Global.Element.EARTH: 0,
		Global.Element.WIND: 0,
		Global.Element.HOLY: 0,
		Global.Element.VOID: 0,
	}
	var skill_changes: Dictionary[String, float] = {
		"strength": 0,
		"intelligence": 0,
		"dexterity": 0,
		"constitution": 0,
		"mastery": 0,
		"critical_strike_chance": 0,
		"critical_strike_damage": 0,
		"block_chance": 0,
		"block_damage_reduction": 0,
		"evasion": 0,
		"presence": 0,
		"range": 0,
		"piety": 0,
		"initiative": 0,
		"mp": 0,
		"ap": 0,
		"max_hp": 0
	}
	for status: Status in character.statuses:
		for key in status.damage_changes:
			damage_bonuses[key] += status.damage_changes[key]
		for key in status.resistance_changes:
			resistance_bonuses[key] += status.resistance_changes[key]
		for key in status.skill_changes:
			skill_changes[key] += status.skill_changes[key]
	for key in damage_bonuses:
		damage[key].flat_bonus = damage_bonuses[key]
	for key in resistance_bonuses:
		resistances[key].flat_bonus = resistance_bonuses[key]
	hp.max = base_hp + skill_changes["max_hp"]
	mp.max = base_mp + skill_changes["mp"]
	ap.max = base_ap + skill_changes["ap"]
	strength.flat_bonus = skill_changes["strength"]
	intelligence.flat_bonus = skill_changes["intelligence"]
	dexterity.flat_bonus = skill_changes["dexterity"]
	constitution.flat_bonus = skill_changes["constitution"]
	mastery.flat_bonus = skill_changes["mastery"]
	critical_strike_chance.flat_bonus = skill_changes["critical_strike_chance"]
	critical_strike_damage.flat_bonus = skill_changes["critical_strike_damage"]
	block_chance.flat_bonus = skill_changes["block_chance"]
	block_damage_reduction.flat_bonus = skill_changes["block_damage_reduction"]
	evasion.flat_bonus = skill_changes["evasion"]
	presence.flat_bonus = skill_changes["presence"]
	range.flat_bonus = skill_changes["range"]
	piety.flat_bonus = skill_changes["piety"]
	initiative.flat_bonus = skill_changes["initiative"]

func _ready() -> void:
	setup()
