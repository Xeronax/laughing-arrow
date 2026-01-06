class_name Status extends Resource

@export var icon: Texture2D
@export var status_name: String
@export_multiline var description: String
@export var skill_changes: Dictionary[String, float] = {
	"strength": 0,
	"intelligence": 0,
	"dexterity": 0,
	"constitution": 0,
	"mastery": 0,
	"critical_strike_chance": 0,
	"critical_strike_damage": 0,
	"block_chance": 0,
	"block_damage_reduction": 0,
	"dodge": 0,
	"presence": 0,
	"range": 0,
	"piety": 0,
	"initiative": 0,
	"mp": 0,
	"ap": 0,
}
@export var resistance_changes: Dictionary[String, float] = {
	"physical": 0,
	"arcane": 0,
	"fire": 0,
	"water": 0,
	"earth": 0,
	"wind": 0,
	"holy": 0,
	"void": 0,
}
@export var damage_changes: Dictionary[String, float] = {
	"physical": 0,
	"arcane": 0,
	"fire": 0,
	"water": 0,
	"earth": 0,
	"wind": 0,
	"holy": 0,
	"void": 0,
}
@export var turns: int = 1
@export var max_stacks: int = 1

var target: BattleCharacter
var source: BattleCharacter = null
var turns_left: int = 1
var current_stacks: int = 1

func format() -> Dictionary[String, String]: 
	return {} 

func stack() -> void:
	var duplicates: Array[Status] = target.statuses.filter(func(status): 
		return (status.status_name == status_name) && status != self)
	print(target.statuses)
	print_debug(duplicates)
	if duplicates.is_empty(): 
		turns_left = turns
		target.statuses.append(self)
		target.status_applied.emit(self, false)
		on_apply()
	elif duplicates[0].current_stacks >= max_stacks:
		return
	else:
		duplicates[0].current_stacks += 1
		duplicates[0].turns_left = turns
		target.status_applied.emit(duplicates[0], true)
		duplicates[0].on_apply()
		return

func on_apply() -> void:
	pass

func on_turn_end() -> void:
	turns_left -= 1
	pass

func on_turn_start() -> void:
	pass

func on_remove() -> void:
	pass
