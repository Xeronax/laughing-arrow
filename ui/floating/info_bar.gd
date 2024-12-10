extends Control

@onready var level_label: Label = $LevelBG/LevelLabel
@onready var name_label: Label = $NameBG/NameLabel
@onready var hp_bar: TextureProgressBar = $Health
@onready var background: Panel = $Background

var target: BattleCharacter = null

func _ready() -> void:
	set_target(target)

func _update() -> void:
	level_label.text = "1"
	name_label.text = target.character_name
	hp_bar.max_value = target.stats.max_hp
	hp_bar.value = target.stats.hp

func _process(delta: float) -> void:
	var offset: Vector2 = Vector2(-22, -(target.hitbox.shape.get_rect().size.y + 7))
	global_position = Global.global_to_ui(target.global_position + offset)

func set_target(t: BattleCharacter) -> void:
	target = t
	print("Connecting to ", target)
	target.stats.hp_changed.connect(_update)
	_update()
