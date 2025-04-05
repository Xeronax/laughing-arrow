extends NinePatchRect

@onready var portrait: TextureRect = $Self
@onready var health_bar: TextureProgressBar = $HealthBar


@export var target: BattleCharacter
@export var current_controller: bool

func _update() -> void:
	health_bar.max_value = target.stats.hp.max
	health_bar.value = target.stats.hp.current

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Global.set_ui_children(self)
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
		if(target.stats.hp_changed.is_connected(_update)):
			target.stats.hp_changed.disconnect(_update)
	if not current_controller:
		target = Global.current_target
	else:
		target = Global.current_controller
	portrait.texture = target.sprite_component.portrait
	_update()
	set_visible(true)
	target.stats.hp_changed.connect(_update)
