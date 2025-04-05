extends NinePatchRect

@onready var spellbar: HBoxContainer = $SpellBar
@onready var healthbar: TextureProgressBar = $ResourceBars/HPBar
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
	var missing_ap_gems: int = target.stats.ap.max - ap_container.get_child_count()
	var missing_mp_gems: int = target.stats.mp.max - mp_container.get_child_count()
	if missing_ap_gems > 0:
		for i in range(missing_ap_gems):
			ap_container.add_child(ap_gem.duplicate())
	else:
		for i in range(abs(missing_ap_gems)):
			ap_container.get_child(0).queue_free()
	if missing_mp_gems > 0:
		for i in range(missing_mp_gems):
			mp_container.add_child(mp_gem.duplicate())
	else:
		for i in range(abs(missing_mp_gems)):
			mp_container.get_child(0).queue_free()
	var used_ap_gems: int = target.stats.ap.max - target.stats.ap.current
	var ap_gems = ap_container.get_children()
	for i in range(used_ap_gems):
		ap_gems.pop_back().queue_free()
	var used_mp_gems: int = target.stats.mp.max - target.stats.mp.current
	var mp_gems = mp_container.get_children()
	for i in range(used_mp_gems):
		mp_gems.pop_back().queue_free()
