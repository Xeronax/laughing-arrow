extends HBoxContainer

var target: BattleCharacter = null

func _ready() -> void:
	Global.current_controller_changed.connect(switch_target)

func switch_target(character: BattleCharacter) -> void:
	target = character
	refresh_spells()

func refresh_spells() -> void:
	var player: BattleCharacter = Global.current_controller
	if not player:
		return
	var spells: Array[Resource] = player.spellbook.duplicate()
	var key: int = 1
	for slot in get_children():
		slot.set_spell(spells.pop_back())
		slot.keybind.text = str(key if key < 10 else 0) + " "
		key += 1
