extends Panel

@onready var level_label: Label = $LevelBG/LevelLabel
@onready var name_label: Label = $NameBG/NameLabel
@onready var hp_bar: TextureProgressBar = $Health
@onready var hp_text: Label = $HealthText
@onready var status_container: HBoxContainer = $Statuses

var tooltip_scene: PackedScene = preload("res://ui/spells/Tooltip.tscn")

var target: BattleCharacter = null

func _ready() -> void:
	set_target(target)
	set_visible(false)
	Global.level_changed.connect(_update)
	

func _update() -> void:
	level_label.text = str(Global.group_level)
	hp_text.text = str(int(target.stats.hp.current)) + '/' + str(int(target.stats.hp.max))
	name_label.text = target.character_name
	hp_bar.max_value = target.stats.hp.max
	hp_bar.value = target.stats.hp.current

func _process(_delta: float) -> void:
	var offset: Vector2 = Vector2(-(get_global_rect().size.y / 2), -(target.hitbox.shape.get_rect().size.y * 1.75))
	global_position = Global.global_to_ui(target.global_position + offset)

func create_status_icon(status: Status) -> void:
	print("Creating status icon")
	var icon: TextureRect = TextureRect.new()
	icon.texture = status.icon
	icon.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT
	icon.expand_mode = TextureRect.EXPAND_FIT_WIDTH
	var tooltip
	icon.mouse_entered.connect(func(): 
		if not status:
			return
		tooltip = tooltip_scene.instantiate()
		Global.ui.add_child(tooltip)
		tooltip.set_ability(status))
	
	icon.mouse_exited.connect(func (): 
		if tooltip: 
			tooltip.queue_free()
	)
	status_container.add_child(icon)

func set_target(t: BattleCharacter) -> void:
	target = t
	#print_debug("Connecting to ", target)
	target.stats.hp.changed.connect(_update)
	target.status_applied.connect(create_status_icon)
	_update()
