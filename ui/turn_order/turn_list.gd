extends HBoxContainer

@export var _battle_manager: Node2D

var _character_box: PackedScene = preload("res://ui/turn_order/CharacterBox.tscn")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_battle_manager.participants_populated.connect(_create_list)

func _get_box(character: BattleCharacter) -> Variant:
	var boxes = get_children()
	for box in boxes:
		if box.character == character:
			return box
	return null

func _create_list(characters: Array) -> void:
	for character in characters:
		_create_character_box(character)

func _create_character_box(character: BattleCharacter) -> void:
	print('Adding character ', character)
	var instance = _character_box.instantiate()
	add_child(instance)
	instance.character_icon.texture = character.sprite_component.portrait
	instance.character = character
	character.stats.hp_changed.connect(instance.update_hp_bar)
	instance.update_hp_bar()
	
