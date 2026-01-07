extends Panel

@onready var status_icon_scene: PackedScene = preload("res://ui/menus/TargetPanelBuffIcon.tscn")

@onready var target_name: RichTextLabel = $Name
@onready var hp_label: RichTextLabel = $HPContainer/HPLabel
@onready var ap_label: RichTextLabel = $APContainer/APLabel
@onready var mp_label: RichTextLabel = $MPContainer/MPLabel
@onready var str_label: RichTextLabel = $STRContainer/STRValue
@onready var int_label: RichTextLabel = $INTContainer/INTValue
@onready var dex_label: RichTextLabel = $DEXContainer/DEXValue
@onready var con_label: RichTextLabel = $CONContainer/CONValue
@onready var mas_label: RichTextLabel = $MASContainer/MASValue
@onready var buff_container: GridContainer = $BuffContainer
@onready var debuff_container: GridContainer = $DebuffContainer
@onready var physical_damage: RichTextLabel = $TabContainer/Elements/PhysicalDamage
@onready var physical_resist: RichTextLabel = $TabContainer/Elements/PhysicalResistance
@onready var arcane_damage: RichTextLabel = $TabContainer/Elements/ArcaneDamage
@onready var arcane_resist: RichTextLabel = $TabContainer/Elements/ArcaneResistance
@onready var fire_damage: RichTextLabel = $TabContainer/Elements/FireDamage
@onready var fire_resist: RichTextLabel = $TabContainer/Elements/FireResistance
@onready var water_damage: RichTextLabel = $TabContainer/Elements/WaterDamage
@onready var water_resist: RichTextLabel = $TabContainer/Elements/WaterResistance
@onready var earth_damage: RichTextLabel = $TabContainer/Elements/EarthDamage
@onready var earth_resist: RichTextLabel = $TabContainer/Elements/EarthResistance
@onready var wind_damage: RichTextLabel = $TabContainer/Elements/WindDamage
@onready var wind_resist: RichTextLabel = $TabContainer/Elements/WindResistance
@onready var holy_damage: RichTextLabel = $TabContainer/Elements/HolyDamage
@onready var holy_resist: RichTextLabel = $TabContainer/Elements/HolyResistance
@onready var void_damage: RichTextLabel = $TabContainer/Elements/VoidDamage
@onready var void_resist: RichTextLabel = $TabContainer/Elements/VoidResistance
@onready var crit_chance: RichTextLabel = $TabContainer/Stats/CritChanceContainer/CritChance
@onready var crit_damage: RichTextLabel = $TabContainer/Stats/CritDamageContainer/CritDamage
@onready var block_chance: RichTextLabel = $TabContainer/Stats/BlockChanceContainer/BlockChance
@onready var block_damage_reudction: RichTextLabel = $TabContainer/Stats/BlockDamageReductionContainer/BlockDamageReduction
@onready var evasion: RichTextLabel = $TabContainer/Stats/EvasionChanceContainer/EvasionChance
@onready var presence: RichTextLabel = $TabContainer/Stats/PresenceContainer/Presence
@onready var initiative: RichTextLabel = $TabContainer/Stats/InitiativeContainer/Initiative
@onready var range: RichTextLabel = $TabContainer/Stats/RangeBonusContainer/RangeBonus
@onready var piety: RichTextLabel = $TabContainer/Stats/PietyContainer/Piety
@onready var exit: Button = $Exit

@export var header_stats_font_size: int = 11
@export var elements_font_size: int = 9
@export var attributes_font_size: int = 12
@export var advanced_stats_font_size: int = 11

var target: BattleCharacter


func _ready() -> void:
	set_visible(false)
	Global.set_ui_children(self)
	Global.current_target_changed.connect(set_target)
	exit.pressed.connect(func(): set_visible(false))

func set_target(t: BattleCharacter) -> void:
	if target:
		for stat in target.stats.get_all_stats():
			if not stat.changed.is_connected(update):
				continue
			stat.changed.disconnect(update)
	target = t
	for stat in target.stats.get_all_stats():
		if stat.changed.is_connected(update):
			continue
		stat.changed.connect(update)
	update()

func color_format(attribute: Stats.Stat) -> String:
	var val: float = attribute.final()
	if attribute.base > val:
		return "[color=red]"
	elif attribute.base < val:
		return "[color=green]"
	else:
		return "[color=white]"

func populate_statuses() -> void:
	var currently_represented_statuses: Array[Status] = []
	currently_represented_statuses.append_array(debuff_container.get_children().map(func(child): return child.status))
	currently_represented_statuses.append_array(buff_container.get_children().map(func(child): return child.status))
	for status in target.statuses:
		if currently_represented_statuses.has(status):
			continue
		var status_icon: NinePatchRect = status_icon_scene.instantiate()
		if status.status_type == Status.StatusType.BUFF:
			buff_container.add_child(status_icon)
		if status.status_type == Status.StatusType.DEBUFF:
			debuff_container.add_child(status_icon)
		status_icon.set_status(status)
		print_debug(status_icon)
	for status in currently_represented_statuses:
		if not target.statuses.has(status):
			if status.status_type == Status.StatusType.BUFF:
				for buff in buff_container.get_children():
					if buff.status == status:
						buff.queue_free()
			else:
				for debuff in debuff_container.get_children():
					if debuff.status == status:
						debuff.queue_free()

func update() -> void:
	target.stats.update()
	target_name.text = "[center]" + str(target.character_name) + "[color=yellow] Lv. " + str(Global.group_level)
	hp_label.text = "[font_size=" + str(header_stats_font_size) + "]%d/%d" % [target.stats.hp.current, target.stats.hp.max]
	mp_label.text = "[font_size=" + str(header_stats_font_size) + "]%d/%d" % [target.stats.mp.current, target.stats.mp.max]
	ap_label.text = "[font_size=" + str(header_stats_font_size) + "]%d/%d" % [target.stats.ap.current, target.stats.ap.max]
	str_label.text = "[font_size=" + str(attributes_font_size) + "]" + color_format(target.stats.strength) + ("%d" % target.stats.strength.final())
	int_label.text = "[font_size=" + str(attributes_font_size) + "]" + color_format(target.stats.intelligence) + ("%d" % target.stats.intelligence.final())
	dex_label.text = "[font_size=" + str(attributes_font_size) + "]" + color_format(target.stats.dexterity) + ("%d" % target.stats.dexterity.final())
	con_label.text = "[font_size=" + str(attributes_font_size) + "]" + color_format(target.stats.constitution) + ("%d" % target.stats.constitution.final())
	mas_label.text = "[font_size=" + str(attributes_font_size) + "]" + color_format(target.stats.mastery) + ("%d" % target.stats.mastery.final())
	crit_chance.text = "[font_size=" + str(advanced_stats_font_size) + "]" +  color_format(target.stats.critical_strike_chance) + ("%d" % round(target.stats.critical_strike_chance.final() * 100)) + '%'
	crit_damage.text = "[font_size=" + str(advanced_stats_font_size) + "]" +  color_format(target.stats.critical_strike_damage) + ("%d" % round(target.stats.critical_strike_damage.final() * 100)) + '%'
	block_chance.text = "[font_size=" + str(advanced_stats_font_size) + "]" +  color_format(target.stats.block_chance) + ("%d" % round(target.stats.block_chance.final() * 100)) + '%'
	block_damage_reudction.text = "[font_size=" + str(advanced_stats_font_size) + "]" +  color_format(target.stats.block_damage_reduction) + ("%d" % round(target.stats.block_damage_reduction.final() * 100)) + '%'
	evasion.text = "[font_size=" + str(advanced_stats_font_size) + "]" +  color_format(target.stats.evasion) + ("%d" % round(target.stats.evasion.final() * 100)) + '%'
	presence.text = "[font_size=" + str(advanced_stats_font_size) + "]" +  color_format(target.stats.presence) + ("%d" % target.stats.presence.final())
	initiative.text = "[font_size=" + str(advanced_stats_font_size) + "]" +  color_format(target.stats.initiative) + ("%d" % target.stats.initiative.final())
	range.text = "[font_size=" + str(advanced_stats_font_size) + "]" +  color_format(target.stats.range) + ("%d" % target.stats.range.final())
	piety.text = "[font_size=" + str(advanced_stats_font_size) + "]" +  color_format(target.stats.piety) + ("%d" % target.stats.piety.final())
	physical_damage.text = "[font_size=" + str(elements_font_size) + "]" + color_format(target.stats.damage.get(Global.Element.PHYSICAL)) + ("%d" % round(target.stats.damage.get(Global.Element.PHYSICAL).final() * 100)) + '%'
	physical_resist.text = "[font_size=" + str(elements_font_size) + "]" + color_format(target.stats.resistances.get(Global.Element.PHYSICAL)) + ("%d" % round(target.stats.resistances.get(Global.Element.PHYSICAL).final() * 100)) + '%'
	arcane_damage.text = "[font_size=" + str(elements_font_size) + "]" + color_format(target.stats.damage.get(Global.Element.ARCANE)) + ("%d" % round(target.stats.damage.get(Global.Element.ARCANE).final() * 100)) + '%'
	arcane_resist.text = "[font_size=" + str(elements_font_size) + "]" + color_format(target.stats.resistances.get(Global.Element.ARCANE)) + ("%d" % round(target.stats.resistances.get(Global.Element.ARCANE).final() * 100)) + '%'
	fire_damage.text = "[font_size=" + str(elements_font_size) + "]" + color_format(target.stats.damage.get(Global.Element.FIRE)) + ("%d" % round(target.stats.damage.get(Global.Element.FIRE).final() * 100)) + '%'
	fire_resist.text = "[font_size=" + str(elements_font_size) + "]" + color_format(target.stats.resistances.get(Global.Element.FIRE)) + ("%d" % round(target.stats.resistances.get(Global.Element.FIRE).final() * 100)) + '%'
	water_damage.text = "[font_size=" + str(elements_font_size) + "]" + color_format(target.stats.damage.get(Global.Element.WATER)) + ("%d" % round(target.stats.damage.get(Global.Element.WATER).final() * 100)) + '%'
	water_resist.text = "[font_size=" + str(elements_font_size) + "]" + color_format(target.stats.resistances.get(Global.Element.WATER)) + ("%d" % round(target.stats.resistances.get(Global.Element.WATER).final() * 100)) + '%'
	earth_damage.text = "[font_size=" + str(elements_font_size) + "]" + color_format(target.stats.damage.get(Global.Element.EARTH)) + ("%d" % round(target.stats.damage.get(Global.Element.EARTH).final() * 100)) + '%'
	earth_resist.text = "[font_size=" + str(elements_font_size) + "]" + color_format(target.stats.resistances.get(Global.Element.EARTH)) + ("%d" % round(target.stats.resistances.get(Global.Element.EARTH).final() * 100)) + '%'
	wind_damage.text = "[font_size=" + str(elements_font_size) + "]" + color_format(target.stats.damage.get(Global.Element.WIND)) + ("%d" % round(target.stats.damage.get(Global.Element.WIND).final() * 100)) + '%'
	wind_resist.text = "[font_size=" + str(elements_font_size) + "]" + color_format(target.stats.resistances.get(Global.Element.WIND)) + ("%d" % round(target.stats.resistances.get(Global.Element.WIND).final() * 100)) + '%'
	holy_damage.text = "[font_size=" + str(elements_font_size) + "]" + color_format(target.stats.damage.get(Global.Element.HOLY)) + ("%d" % round(target.stats.damage.get(Global.Element.HOLY).final() * 100)) + '%'
	holy_resist.text = "[font_size=" + str(elements_font_size) + "]" + color_format(target.stats.resistances.get(Global.Element.HOLY)) + ("%d" % round(target.stats.resistances.get(Global.Element.HOLY).final() * 100)) + '%'
	void_damage.text = "[font_size=" + str(elements_font_size) + "]" + color_format(target.stats.damage.get(Global.Element.VOID)) + ("%d" % round(target.stats.damage.get(Global.Element.VOID).final() * 100)) + '%'
	void_resist.text = "[font_size=" + str(elements_font_size) + "]" + color_format(target.stats.resistances.get(Global.Element.VOID)) + ("%d" % round(target.stats.resistances.get(Global.Element.VOID).final() * 100)) + '%'
	populate_statuses()
