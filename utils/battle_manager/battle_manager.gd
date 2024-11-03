extends Node2D

var characters: Array = []
var participants_in_turn_order: Array = []
var player_team: Array = []
var enemy_team: Array = []
var current_turn_idx: int = 0
var current_round: int = 1

signal participants_populated(participants)

func get_player(idx: int) -> BattleCharacter:
	return participants_in_turn_order[idx]

func _sort_by_initiative(a: BattleCharacter, b: BattleCharacter) -> bool:
	if a.stats.initiative > b.stats.initiative:
		return true
	return false

func set_turn_order() -> void:
	var temp_array = characters
	temp_array.sort_custom(_sort_by_initiative)
	participants_in_turn_order = temp_array

func set_teams() -> void:
	for character in characters:
		if character.player_team:
			player_team.append(character)
		else:
			enemy_team.append(character)
	
	for character in enemy_team:
		character.reversed = true

func start_battle(new_characters: Array) -> void:
	characters = new_characters
	for character in characters:
		character.turn_ending.connect(next_turn)
	set_turn_order()
	set_teams()
	emit_signal('participants_populated', participants_in_turn_order)
	participants_in_turn_order[current_turn_idx].start_turn()

func next_turn() -> void:
	current_turn_idx+=1
	if current_turn_idx == characters.size():
		current_turn_idx = 0
		current_round += 1
	var current_player: BattleCharacter = get_player(current_turn_idx)
	current_player.start_turn()
