extends AspectRatioContainer

@onready var icon: TextureRect = $SpellIcon
@onready var button: Button = $Button

@export var player: BattleCharacter

var current_spell: Spell


func _ready() -> void:
	mouse_entered.connect(func (): Global.mouse_on_ui = true)
	mouse_exited.connect(func (): Global.mouse_on_ui = false)
	await(player.ready)
	var spellbook = player.spellbook
	var spells: Array = spellbook
	current_spell = spells[0]
	icon.set_texture(current_spell.spell_icon)
	button.pressed.connect(current_spell.cast)
