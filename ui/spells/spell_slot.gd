extends AspectRatioContainer

@onready var icon: TextureRect = $SpellIcon
@onready var button: Button = $Button
@onready var keybind: Label = $Keybind

@export var tooltip_scene: PackedScene

var current_spell: Spell
var tooltip: Node = null

func set_spell(s: Spell) -> void:
	if s == null:
		return
	current_spell = s
	icon.set_texture(s.spell_icon)
	for sig in button.pressed.get_connections():
		button.pressed.disconnect(sig.callable)
	button.pressed.connect(s.cast)

func _ready() -> void:
	Global.set_ui_children(self)
	button.mouse_entered.connect(func (): 
		if not current_spell:
			return
		tooltip = tooltip_scene.instantiate()
		Global.ui.add_child(tooltip)
		tooltip.set_spell(current_spell))
	button.mouse_exited.connect(func (): 
		if tooltip: 
			tooltip.queue_free()
			)
