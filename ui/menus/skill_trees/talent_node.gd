extends GraphNode

@onready var button: Button = $Button

@export var ability: Resource
@export var max_rank: int = 1
@export var rank: int = 0

var tooltip_scene: PackedScene = preload("res://ui/spells/Tooltip.tscn")
var tooltip: Node = null

func _ready() -> void:
	if ability is Spell:
		button.icon = ability.spell_icon
	elif ability is Talent:
		button.icon = ability.icon
	
	update()
	
	button.mouse_entered.connect(func (): 
		if not ability:
			return
		tooltip = tooltip_scene.instantiate()
		Global.ui.add_child(tooltip)
		tooltip.set_ability(ability))
	
	button.mouse_exited.connect(func (): 
		if tooltip: 
			tooltip.queue_free()
	)

func update() -> void:
	title = "   " + str(rank) + "/" + str(max_rank)
	if rank < 1:
		return
	if Global.current_controller == null:
		return
	if not Global.current_controller.spellbook.has(ability):
		Global.current_controller.add_spell(ability)
