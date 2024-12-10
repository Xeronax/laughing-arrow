extends Control

@onready var portrait: TextureRect = $Portrait/Self
@onready var ap_label: Label = $APFrame/APLabel
@onready var mp_label: Label = $MPFrame/MPLabel
@onready var health_bar: TextureProgressBar = $HealthBar
@onready var hp_panel: Panel = $HealthBar/Panel
@onready var hp_label: Label = $HealthBar/HealthText

@export var target: BattleCharacter
@export var current_controller: bool

func _update() -> void:
	ap_label.text = str(target.stats.ap)
	mp_label.text = str(target.stats.mp)
	hp_label.text = str(target.stats.hp)
	health_bar.max_value = target.stats.max_hp
	health_bar.value = target.stats.hp

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Global.set_ui_children(self)
	if not current_controller:
		hp_label.position.x = -40
		hp_panel.position.x = -40
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
		if(target.stats.ap_changed.is_connected(_update)):
			target.stats.ap_changed.disconnect(_update)
		if(target.stats.mp_changed.is_connected(_update)):
			target.stats.mp_changed.disconnect(_update)
		if(target.stats.hp_changed.is_connected(_update)):
			target.stats.hp_changed.disconnect(_update)
	if not current_controller:
		target = Global.current_target
	else:
		target = character
	portrait.texture = target.sprite_component.portrait
	_update()
	set_visible(true)
	target.stats.ap_changed.connect(_update)
	target.stats.mp_changed.connect(_update)
	target.stats.hp_changed.connect(_update)
