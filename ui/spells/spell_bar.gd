extends NinePatchRect

@export var player: BattleCharacter

func refresh_spells() -> void:
	if not player:
		return
	var spells: Array = player.spellbook
	var key: int = 1
	for slot in get_children():
		slot.set_spell(spells.pop_back())
		slot.keybind.text = str(key if key < 10 else 0) + " "
		key += 1
