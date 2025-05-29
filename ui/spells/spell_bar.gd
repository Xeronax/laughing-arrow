extends NinePatchRect

@onready var spellbar: HBoxContainer = $SpellBar
@onready var healthbar: TextureProgressBar = $ResourceBars/HPBar
@onready var exp_bar: ProgressBar = $EXPBar
@onready var ap_container: HBoxContainer = $ResourceBars/APContainer
@onready var mp_container: HBoxContainer = $ResourceBars/MPContainer
@onready var ap_gem: TextureRect = $ResourceBars/APContainer/APGem
@onready var mp_gem: TextureRect = $ResourceBars/MPContainer/MPGem
@onready var hp_label: Label = $ResourceBars/HPLabel
@onready var mp_label: Label = $ResourceBars/MPLabel
@onready var ap_label: Label = $ResourceBars/APLabel

var target: BattleCharacter = null

func switch_target(character: BattleCharacter) -> void:
	target = character
	character.stats.hp_changed.connect(update)
	character.stats.mp_changed.connect(update)
	character.stats.ap_changed.connect(update)
	character.exp_changed.connect(update)
	refresh_spells()
	update()

func refresh_spells() -> void:
	var player: BattleCharacter = Global.current_controller
	if not player:
		return
	var spells: Array = player.spellbook.duplicate()
	var key: int = 1
	for slot in spellbar.get_children():
		slot.set_spell(spells.pop_back())
		slot.keybind.text = str(key if key < 10 else 0) + " "
		key += 1

func update() -> void:
	healthbar.max_value = target.stats.hp.max
	healthbar.value = target.stats.hp.current
	hp_label.text = str(target.stats.hp.current) + " / " + str(target.stats.hp.max)
	ap_label.text = str(target.stats.ap.current) + " / " + str(target.stats.ap.max)
	mp_label.text = str(target.stats.mp.current) + " / " + str(target.stats.mp.max)
	exp_bar.max_value = target.exp_to_next_level
	exp_bar.value = target.exp
	for gem: Node in ap_container.get_children():
		if gem.get_index() in range(target.stats.ap.current):
			gem.set_visible(true)
		else:
			gem.set_visible(false)
	for gem: Node in mp_container.get_children():
		if gem.get_index() in range(target.stats.mp.current):
			gem.set_visible(true)
		else:
			gem.set_visible(false)
