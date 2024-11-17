extends Control

@onready var portrait: TextureRect = $Portrait/TextureRect
@onready var ap_label: Label = $APFrame/APLabel
@onready var mp_label: Label = $MPFrame/MPLabel

@export var target: BattleCharacter

func _update() -> void:
	ap_label.text = str(target.stats.ap)
	mp_label.text = str(target.stats.mp)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	await(target.ready)
	switch_target(target)
	mouse_entered.connect(func (): Global.mouse_on_ui = true)
	mouse_exited.connect(func (): Global.mouse_on_ui = false)

func switch_target(character: BattleCharacter) -> void:
	if target:
		if(target.stats.ap_changed.is_connected(_update)):
			target.stats.ap_changed.disconnect(_update)
		if(target.stats.mp_changed.is_connected(_update)):
			target.stats.mp_changed.disconnect(_update)
	target = character
	portrait.texture = target.sprite_component.portrait
	_update()
	target.stats.ap_changed.connect(_update)
	target.stats.mp_changed.connect(_update)
