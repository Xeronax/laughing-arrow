extends Control

@onready var name_label: RichTextLabel = $NameLabel
@onready var strength: RichTextLabel = $BaseStatContainer/STRContainer/STRValue
@onready var intelligence: RichTextLabel = $BaseStatContainer/INTContainer/INTValue
@onready var dexterity: RichTextLabel = $BaseStatContainer/DEXContainer/DEXValue
@onready var constitution: RichTextLabel = $BaseStatContainer/CONContainer/CONValue
@onready var mastery: RichTextLabel = $BaseStatContainer/MASContainer/MASValue
@onready var hp: RichTextLabel = $HPContainer/HPLabel
@onready var mp: RichTextLabel = $MPContainer/MPLabel
@onready var ap: RichTextLabel = $APContainer/APLabel
@onready var physical_damage: RichTextLabel = $SecondaryStatContainer/Elements/PhysicalDamage
@onready var physical_resistance: RichTextLabel = $SecondaryStatContainer/Elements/PhysicalDamage
@onready var arcane_damage: RichTextLabel = $SecondaryStatContainer/Elements/ArcaneDamage
@onready var arcane_resistance: RichTextLabel = $SecondaryStatContainer/Elements/ArcaneResistance
@onready var fire_damage: RichTextLabel = $SecondaryStatContainer/Elements/FireDamage
@onready var fire_resistance: RichTextLabel = $SecondaryStatContainer/Elements/FireResistance
@onready var water_damage: RichTextLabel = $SecondaryStatContainer/Elements/WaterDamage
@onready var water_resistance: RichTextLabel = $SecondaryStatContainer/Elements/WaterResistance
@onready var earth_damage: RichTextLabel = $SecondaryStatContainer/Elements/EarthDamage
@onready var earth_resistance: RichTextLabel = $SecondaryStatContainer/Elements/EarthResistance
@onready var wind_damage: RichTextLabel = $SecondaryStatContainer/Elements/WindDamage
@onready var wind_resistance: RichTextLabel = $SecondaryStatContainer/Elements/WindResistance
@onready var holy_damage: RichTextLabel = $SecondaryStatContainer/Elements/HolyDamage
@onready var holy_resistance: RichTextLabel = $SecondaryStatContainer/Elements/HolyResistance
@onready var void_damage: RichTextLabel = $SecondaryStatContainer/Elements/VoidDamage
@onready var void_resistance: RichTextLabel = $SecondaryStatContainer/Elements/VoidDamage
@onready var critical_strike_chance: RichTextLabel = $"SecondaryStatContainer/Advanced Stats/CritChance"
@onready var critical_strike_damage: RichTextLabel = $"SecondaryStatContainer/Advanced Stats/CritDamage"
@onready var block_chance: RichTextLabel = $"SecondaryStatContainer/Advanced Stats/BlockChance"
@onready var block_damage_reduction: RichTextLabel = $"SecondaryStatContainer/Advanced Stats/BlockDamageReduction"
@onready var evasion: RichTextLabel = $"SecondaryStatContainer/Advanced Stats/Evasion"
@onready var presence: RichTextLabel = $"SecondaryStatContainer/Advanced Stats/Presence"
@onready var initiative: RichTextLabel = $"SecondaryStatContainer/Advanced Stats/Initiative"
@onready var range: RichTextLabel = $"SecondaryStatContainer/Advanced Stats/RangeBonus"
@onready var piety: RichTextLabel = $"SecondaryStatContainer/Advanced Stats/Piety"

var Element = Global.Element

func update() -> void:
	var char: BattleCharacter = Global.current_controller
	name_label.text = "[center]" + str(char.character_name) + "[color=yellow] Lv. " + str(Global.group_level)
	hp.text = "%d/%d" % [char.stats.hp.current, char.stats.hp.max]
	mp.text = "%d/%d" % [char.stats.mp.current, char.stats.mp.max]
	ap.text = "%d/%d" % [char.stats.ap.current, char.stats.ap.max]
	strength.text = color_format(char.stats.strength) + ("%d" % char.stats.strength.final())
	intelligence.text = color_format(char.stats.intelligence) + ("%d" % char.stats.intelligence.final())
	dexterity.text = color_format(char.stats.dexterity) + ("%d" % char.stats.dexterity.final())
	constitution.text = color_format(char.stats.constitution) + ("%d" % char.stats.constitution.final())
	mastery.text = color_format(char.stats.mastery) + ("%d" % char.stats.mastery.final())
	critical_strike_chance.text = color_format(char.stats.critical_strike_chance) + ("%d" % round(char.stats.critical_strike_chance.final() * 100)) + '%'
	critical_strike_damage.text = color_format(char.stats.critical_strike_damage) + ("%d" % round(char.stats.critical_strike_damage.final() * 100)) + '%'
	block_chance.text = color_format(char.stats.block_chance) + ("%d" % round(char.stats.block_chance.final() * 100)) + '%'
	block_damage_reduction.text = color_format(char.stats.block_damage_reduction) + ("%d" % round(char.stats.block_damage_reduction.final() * 100)) + '%'
	evasion.text = color_format(char.stats.evasion) + ("%d" % round(char.stats.evasion.final() * 100)) + '%'
	presence.text = color_format(char.stats.presence) + ("%d" % char.stats.presence.final())
	initiative.text = color_format(char.stats.initiative) + ("%d" % char.stats.initiative.final())
	range.text = color_format(char.stats.range) + ("%d" % char.stats.range.final())
	piety.text = color_format(char.stats.piety) + ("%d" % char.stats.piety.final())
	physical_damage.text = color_format(char.stats.damage.get(Element.PHYSICAL)) + ("%d" % round(char.stats.damage.get(Element.PHYSICAL).final() * 100)) + '%'
	physical_resistance.text = color_format(char.stats.resistances.get(Element.PHYSICAL)) + ("%d" % round(char.stats.resistances.get(Element.PHYSICAL).final() * 100)) + '%'
	arcane_damage.text = color_format(char.stats.damage.get(Element.ARCANE)) + ("%d" % round(char.stats.damage.get(Element.ARCANE).final() * 100)) + '%'
	arcane_resistance.text = color_format(char.stats.resistances.get(Element.ARCANE)) + ("%d" % round(char.stats.resistances.get(Element.ARCANE).final() * 100)) + '%'
	fire_damage.text = color_format(char.stats.damage.get(Element.FIRE)) + ("%d" % round(char.stats.damage.get(Element.FIRE).final() * 100)) + '%'
	fire_resistance.text = color_format(char.stats.resistances.get(Element.FIRE)) + ("%d" % round(char.stats.resistances.get(Element.FIRE).final() * 100)) + '%'
	water_damage.text = color_format(char.stats.damage.get(Element.WATER)) + ("%d" % round(char.stats.damage.get(Element.WATER).final() * 100)) + '%'
	water_resistance.text = color_format(char.stats.resistances.get(Element.WATER)) + ("%d" % round(char.stats.resistances.get(Element.WATER).final() * 100)) + '%'
	earth_damage.text = color_format(char.stats.damage.get(Element.EARTH)) + ("%d" % round(char.stats.damage.get(Element.EARTH).final() * 100)) + '%'
	earth_resistance.text = color_format(char.stats.resistances.get(Element.EARTH)) + ("%d" % round(char.stats.resistances.get(Element.EARTH).final() * 100)) + '%'
	wind_damage.text = color_format(char.stats.damage.get(Element.WIND)) + ("%d" % round(char.stats.damage.get(Element.WIND).final() * 100)) + '%'
	wind_resistance.text = color_format(char.stats.resistances.get(Element.WIND)) + ("%d" % round(char.stats.resistances.get(Element.WIND).final() * 100)) + '%'
	holy_damage.text = color_format(char.stats.damage.get(Element.HOLY)) + ("%d" % round(char.stats.damage.get(Element.HOLY).final() * 100)) + '%'
	holy_resistance.text = color_format(char.stats.resistances.get(Element.HOLY)) + ("%d" % round(char.stats.resistances.get(Element.HOLY).final() * 100)) + '%'
	void_damage.text = color_format(char.stats.damage.get(Element.VOID)) + ("%d" % round(char.stats.damage.get(Element.VOID).final() * 100)) + '%'
	void_resistance.text = color_format(char.stats.resistances.get(Element.VOID)) + ("%d" % round(char.stats.resistances.get(Element.VOID).final() * 100)) + '%'

func color_format(attribute: Stats.Stat) -> String:
	var val: float = attribute.final()
	if attribute.base > val:
		return "[color=red][center]"
	elif attribute.base < val:
		return "[color=green][center]"
	else:
		return "[color=white][center]"

func _ready() -> void:
	get_parent().tab_changed.connect(func (_tab: int): update())
