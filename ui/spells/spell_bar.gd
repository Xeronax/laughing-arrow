extends HBoxContainer

var target: BattleCharacter = null

func _ready() -> void:
	Global.current_controller_changed.connect(switch_target)

func switch_target(character: BattleCharacter) -> void:
	target = character
	refresh_spells()

func refresh_spells() -> void:
	var skill_tree: GraphEdit = Global.ui.get_node("CharacterPanel/SkillTree")
	if not skill_tree:
		print_debug("SkillTree not found or not ready, returning.")
	skill_tree.update()
	if not target:
		print_debug("Spell refresh found no player, returning.")
		return
	var spells: Array[Resource] = target.spellbook.duplicate()
	var key: int = 1
	for slot in get_children():
		slot.set_spell(spells.pop_front())
		slot.keybind.text = str(key if key < 10 else 0) + " "
		key += 1
