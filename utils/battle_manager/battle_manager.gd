extends Node2D
## The BattleManager controls starting battles and the flow of turns
##
## 
var characters: Array[BattleCharacter] = [] ## All BattleCharacters, including dead
var participants_in_turn_order: Array[BattleCharacter] = [] ## Alive BattleCharacters sorted in turn order
var player_team: Array[BattleCharacter] = [] ## Player team, including dead
var enemy_team: Array[BattleCharacter] = [] ## Enemy team, including dead
var current_turn_idx: int = 0 ## The index of the participants_in_turn_order array for the BattleCharacter whose turn it is
var current_round: int = 1 ## A round consists of a full cycle of turns for each BattleCharacter
var current_character: BattleCharacter ## The character whose turn it is

signal participants_populated(participants: Array[BattleCharacter]) ## Emitted when participants_in_turn_order array is initialized
signal turn_starting(character: BattleCharacter)
signal round_end

## Sorts the participants_in_turn_order array by initiative
func set_turn_order() -> void:
	var temp_array = characters
	temp_array.sort_custom(func (a: BattleCharacter, b: BattleCharacter): 
		return a.stats.initiative.current > b.stats.initiative.current
	)
	participants_in_turn_order = temp_array

func set_teams() -> void:
	for character in characters:
		if character.player_team:
			player_team.append(character)
		else:
			enemy_team.append(character)
	
	for character in enemy_team:
		character.reversed = true # Hacky way to make mobs spawn in looking toward the player

## Starts battle by setting up turn order, teams, and then starting the first turn
func start_battle(new_characters: Array[BattleCharacter]) -> void:
	print_debug("Starting battle with participants: ", new_characters)
	characters = new_characters
	for character in characters:
		character.turn_ending.connect(next_turn)
	set_turn_order()
	set_teams()
	participants_populated.emit(participants_in_turn_order)
	next_turn(true)

func next_turn(first_turn: bool = false) -> void:
	if not first_turn:
		current_turn_idx+=1
	if current_turn_idx == participants_in_turn_order.size():
		current_turn_idx = 0
		current_round += 1
	current_character = participants_in_turn_order[current_turn_idx]
	print("New Turn: ", current_character)
	current_character.start_turn()
