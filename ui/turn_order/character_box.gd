extends Control

@onready var character_icon: TextureRect = $ARContainer/CharacterImage
@onready var focus_button: Button = $ARContainer/Button
@onready var border: TextureRect = $ARContainer/Border
@onready var hp_bar: TextureProgressBar = $HealthBar

var character: BattleCharacter

func update_hp_bar() -> void:
	hp_bar.max_value = character.stats.hp.max
	hp_bar.value = character.stats.hp.current
	print("Updating HP for ", character)

func _ready() -> void:
	focus_button.pressed.connect(_on_click)
	Global.set_ui_children(self)

func _on_click() -> void:
	Global.set_current_target(character)
