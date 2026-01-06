extends Panel

@onready var level_label: Label = $LevelBG/LevelLabel
@onready var name_label: Label = $NameBG/NameLabel
@onready var hp_bar: TextureProgressBar = $Health
@onready var hp_text: Label = $HealthText
@onready var status_container: HBoxContainer = $Statuses

var tooltip_scene: PackedScene = preload("res://ui/spells/Tooltip.tscn")
var status_icon_scene: PackedScene = preload("res://ui/floating/StatusIcon.tscn")

var target: BattleCharacter = null
var tooltip: Panel

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

func find_status(s: Status) -> AspectRatioContainer:
	for status_icon in status_container.get_children():
		if status_icon.status.status_name == s.status_name:
			return status_icon
	return null

func create_status_icon(status: Status, stack: bool = false) -> void:
	if stack:
		find_status(status).update()
		return
	print_debug("Creating status icon")
	var status_node: AspectRatioContainer = status_icon_scene.instantiate()
	status_container.add_child(status_node)
	status_node.set_status(status)
	status_node.mouse_entered.connect(func(): 
		if not status:
			return
		tooltip = tooltip_scene.instantiate()
		Global.ui.add_child(tooltip)
		tooltip.set_ability(status))
	
	status_node.mouse_exited.connect(func (): 
		if tooltip: 
			tooltip.queue_free()
	)

func remove_status(status: Status) -> void:
	find_status(status).queue_free()

func set_target(t: BattleCharacter) -> void:
	target = t
	#print_debug("Connecting to ", target)
	target.stats.hp.changed.connect(_update)
	target.status_applied.connect(create_status_icon)
	target.status_removed.connect(remove_status)
	_update()
