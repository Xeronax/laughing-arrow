extends Panel

@export var ap_gem: Texture2D
@export var mp_gem: Texture2D

@onready var icon_texture: TextureRect = $TextureRect
@onready var name_label: Label = $Name
@onready var type_label: Label = $Type
@onready var range_label: Label = $RangeContainer/Range
@onready var cooldown_label: Label = $CooldownContainer/Cooldown
@onready var cost: HBoxContainer = $CostContainer 
@onready var description: RichTextLabel = $Description

@onready var range: HBoxContainer = $RangeContainer
@onready var cooldown: HBoxContainer = $CooldownContainer

func _process(delta: float) -> void:
	global_position = get_global_mouse_position() + Vector2(0, -(get_rect().size.y + 2))

func set_ability(ability: Resource) -> void:
	if ability == null:
		return
	if ability is Spell:
		display_spell(ability)
	elif ability is Talent:
		display_talent(ability)
	elif ability is Status:
		display_status(ability)

func display_spell(s: Spell) -> void:
	icon_texture.texture = s.spell_icon
	name_label.text = s.spell_name
	type_label.text = "Spell"
	range_label.text = str(s.spell_range)
	cooldown_label.text = str(s.cooldown) + (" turn" if s.cooldown == 1 else " turns")
	for i in range(s.ap_cost):
		var gem = TextureRect.new()
		gem.texture = ap_gem
		gem.expand_mode = TextureRect.EXPAND_FIT_WIDTH
		cost.add_child(gem)
	for i in range(s.mp_cost):
		var gem = TextureRect.new()
		gem.texture = mp_gem
		gem.expand_mode = TextureRect.EXPAND_FIT_WIDTH
		cost.add_child(gem)
	var formatting_dict: Dictionary[String, String] = {
		"name": s.spell_name,
		"minimum_damage": str(s.minimum_damage),
		"maximum_damage": str(s.maximum_damage),
		"range": str(s.spell_range)
	}
	description.text = "[color=WHITE][font='res://assets/Lato/Lato-Black.ttf'][font_size=13]" + s.description.format(formatting_dict)

func display_talent(t: Talent) -> void:
	if t == null:
		return
	icon_texture.texture = t.icon
	name_label.text = t.talent_name
	type_label.text = "Talent"
	range.set_visible(false)
	cooldown.set_visible(false)
	var formatting_dict: Dictionary[String, String] = {
		"name": t.talent_name,
	}
	var custom_format: Dictionary[String, String] = t.format()
	if(custom_format):
		for key in custom_format:
			formatting_dict[key] = custom_format[key]
	description.text = "[color=WHITE][font='res://assets/Lato/Lato-Black.ttf'][font_size=13]" + t.description.format(formatting_dict)

func display_status(s: Status) -> void:
	if s == null:
		return
	icon_texture.texture = s.icon
	name_label.text = s.status_name
	type_label.text = "Status"
	range.set_visible(false)
	cooldown.set_visible(false)
	var formatting_dict: Dictionary[String, String] = {
		"name": s.status_name
	}
	var custom_format: Dictionary[String, String] = s.format()
	if(custom_format):
		for key in custom_format:
			formatting_dict[key] = custom_format[key]
	description.text = "[color=WHITE][font='res://assets/Lato/Lato-Black.ttf'][font_size=13]" + s.description.format(formatting_dict)
