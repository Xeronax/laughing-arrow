extends AspectRatioContainer

@onready var icon: TextureRect = $SpellIcon
@onready var button: Button = $SpellIcon/Button
@onready var keybind: Label = $Keybind
@onready var cooldown_shade: ColorRect = $SpellIcon/CooldownShade
@onready var cooldown_text: Label = $SpellIcon/CooldownText

@export var tooltip_scene: PackedScene

var current_spell: Spell
var tooltip: Node = null

func set_spell(new_spell: Spell) -> void:
	if new_spell == null:
		return
	
	for current_signal in button.pressed.get_connections():
		button.pressed.disconnect(current_signal.callable)
	
	current_spell = new_spell
	
	icon.set_texture(new_spell.spell_icon)
	
	button.pressed.connect(func(): 
		new_spell.cast())
	
	new_spell.cooldown_ticked.connect(tick_cooldown)
	
	new_spell.casted.connect(func(): 
		cooldown_text.set_visible(true)
		cooldown_shade.set_visible(true))

func _ready() -> void:
	Global.set_ui_children(self)
	cooldown_shade.set_visible(false)
	cooldown_text.set_visible(false)
	button.mouse_entered.connect(func (): 
		if not current_spell:
			return
		tooltip = tooltip_scene.instantiate()
		Global.ui.add_child(tooltip)
		tooltip.set_ability(current_spell))
	button.mouse_exited.connect(func (): 
		if tooltip: 
			tooltip.queue_free()
			)



func tick_cooldown() -> void:
	var current_cd: int = current_spell.current_cooldown
	if current_cd <= 0:
		cooldown_text.set_visible(false)
		cooldown_shade.set_visible(false)
	else:
		var cd_ratio: float = float(current_cd) / float(current_spell.cooldown)
		cooldown_shade.set_scale(Vector2(1, cd_ratio))
		cooldown_text.text = str(current_cd)
