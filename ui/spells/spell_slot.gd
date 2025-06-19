extends AspectRatioContainer

@onready var icon: TextureRect = $SpellIcon
@onready var button: Button = $Button
@onready var keybind: Label = $Keybind

@export var tooltip_scene: PackedScene

var current_spell: Spell
var tooltip: Node = null

func set_spell(new_spell: Spell) -> void:
	if new_spell == null:
		return
	current_spell = new_spell
	icon.set_texture(new_spell.spell_icon)
	for current_signal in button.pressed.get_connections():
		button.pressed.disconnect(current_signal.callable)
	button.pressed.connect(new_spell.cast)

func _ready() -> void:
	Global.set_ui_children(self)
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
