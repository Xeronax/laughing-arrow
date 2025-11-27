extends ScrollContainer

@onready var container: VBoxContainer = $VBox

var _character_box: PackedScene = preload("res://ui/turn_order/CharacterBox.tscn")
var current_turn: Control = null
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	await(Global.all_ready)
	var temp: Array[BattleCharacter] = Global.battle_manager.participants_in_turn_order.duplicate()
	temp.reverse()
	for character in temp:
		_create_character_box(character)
	Global.battle_manager.turn_starting.connect(_next_turn)
	Global.set_ui_children(self)

func _next_turn(_current_turn_character: BattleCharacter = null) -> void:
	var child = container.get_children()[0]
	print("Popping ", container.get_children()[0].character)
	container.remove_child(child)
	container.add_child(child)

func _get_box(character: BattleCharacter) -> Variant:
	var boxes = get_children()
	for box in boxes:
		if box.character == character:
			return box
	return null

func _create_character_box(character: BattleCharacter) -> void:
	var instance = _character_box.instantiate()
	container.add_child(instance)
	instance.character_icon.texture = character.sprite_component.portrait
	instance.character = character
	character.stats.hp.changed.connect(instance.update_hp_bar)
	instance.update_hp_bar()
	print(instance)
	Global.set_ui_children(instance)
