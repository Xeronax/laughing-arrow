extends VSplitContainer

@onready var character_icon: TextureRect = $ARContainer/CharacterImage
@onready var focus_button: Button = $ARContainer/Button
@onready var border: TextureRect = $ARContainer/Border
@onready var hp_bar: ProgressBar = $HealthBar

var character: BattleCharacter

func update_hp_bar() -> void:
	hp_bar.max_value = character.stats.max_hp
	hp_bar.value = character.stats.hp
	print("Updating HP for ", character)
