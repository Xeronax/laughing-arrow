extends Control

@onready var portrait: TextureRect = $Portrait/TextureRect
@onready var ap_label: Label = $APFrame/APLabel
@onready var mp_label: Label = $MPFrame/MPLabel

@export var target: BattleCharacter

func set_ap(ap: int) -> void:
	ap_label.text = str(ap)

func set_mp(mp: int) -> void:
	mp_label.text = str(mp)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	await(target.ready)
	switch_target(target)
	pass # Replace with function body.

func switch_target(character: BattleCharacter) -> void:
	if target:
		if(target.stats.ap_changed.is_connected(set_ap)):
			target.stats.ap_changed.disconnect(set_ap)
		if(target.stats.mp_changed.is_connected(set_mp)):
			target.stats.mp_changed.disconnect(set_mp)
	target = character
	portrait.texture = target.sprite_component.portrait
	ap_label.text = str(target.stats.ap)
	mp_label.text = str(target.stats.mp)
	target.stats.ap_changed.connect(set_ap)
	target.stats.mp_changed.connect(set_mp)
	
