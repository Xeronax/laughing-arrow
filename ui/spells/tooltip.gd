extends Panel

@onready var icon_texture: TextureRect = $TextureRect
@onready var name_label: Label = $Name
@onready var type_label: Label = $Type
@onready var range_label: Label = $RangeContainer/Range
@onready var cooldown_label: Label = $CooldownContainer/Cooldown
@onready var cost_label: Label = $APContainer/APCost
@onready var description: RichTextLabel = $Description

func _process(delta: float) -> void:
	global_position = get_global_mouse_position() + Vector2(0, -(get_rect().size.y + 2))

func set_spell(s: Spell) -> void:
	if s == null:
		return
	icon_texture.texture = s.spell_icon
	name_label.text = s.spell_name
	type_label.text = "Spell"
	range_label.text = str(s.spell_range)
	cost_label.text = str(s.ap_cost)
	cooldown_label.text = str(s.cooldown) + (" turn" if s.cooldown == 1 else " turns")
	var formatting_dict: Dictionary[String, String] = {
		"name": s.spell_name,
		"minimum_damage": str(s.minimum_damage),
		"maximum_damage": str(s.maximum_damage),
	}
	description.text = "[color=WHITE][font='res://assets/Lato/Lato-Black.ttf'][font_size=13]" + s.description.format(formatting_dict) 
