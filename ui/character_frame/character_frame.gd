extends Control

@onready var portrait: TextureRect = $Portrait/Self
@onready var health_bar: TextureProgressBar = $ResourcePanel/HealthBar
@onready var ap_container: HBoxContainer = $ResourcePanel/APContainer
@onready var mp_container: HBoxContainer = $ResourcePanel/MPContainer
@onready var ap_gem: TextureRect = $ResourcePanel/APContainer/APGem
@onready var mp_gem: TextureRect = $ResourcePanel/MPContainer/MPGem


@export var target: BattleCharacter
@export var current_controller: bool

func _update() -> void:
	health_bar.max_value = target.stats.hp.max
	health_bar.value = target.stats.hp.current
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

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Global.set_ui_children(self)
	Global.current_controller_changed.connect(switch_target)
	if not current_controller:
		portrait.set_flip_h(true)
		set_visible(false)
		await(get_tree().create_timer(1).timeout)
		Global.current_target_changed.connect(switch_target)
	if not target:
		return
	await(target.ready)
	switch_target(target)


func switch_target(character: BattleCharacter = null) -> void:
	if target:
		for target_signals: Signal in [target.stats.hp_changed, target.stats.ap_changed, target.stats.mp_changed]:
			if(target_signals.is_connected(_update)):
				target_signals.disconnect(_update)
	if not current_controller:
		target = Global.current_target
	else:
		target = Global.current_controller
	portrait.texture = target.sprite_component.portrait
	var character_signals: Array[Signal] = [character.stats.hp_changed, character.stats.ap_changed, character.stats.mp_changed]
	for character_signal: Signal in character_signals:
		character_signal.connect(_update)
	_update()
	set_visible(true)
