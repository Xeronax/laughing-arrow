extends Panel

@onready var level_label: Label = $LevelBG/LevelLabel
@onready var name_label: Label = $NameBG/NameLabel
@onready var hp_bar: TextureProgressBar = $Health

var target: BattleCharacter = null

func _ready() -> void:
	set_target(target)
	set_visible(false)

func _update() -> void:
	level_label.text = "1"
	name_label.text = target.character_name
	hp_bar.max_value = target.stats.hp.max
	hp_bar.value = target.stats.hp.current

func _process(delta: float) -> void:
	var offset: Vector2 = Vector2(-(get_global_rect().size.y / 2), -(target.hitbox.shape.get_rect().size.y * 1.25))
	global_position = Global.global_to_ui(target.global_position + offset)

func set_target(t: BattleCharacter) -> void:
	target = t
	print("Connecting to ", target)
	target.stats.hp.changed.connect(_update)
	_update()
