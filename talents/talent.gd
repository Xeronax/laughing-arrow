class_name Talent extends Resource

@export_multiline var description: String # RichText
@export var icon: Texture2D
@export var talent_name: String

var character: BattleCharacter

# Optional, for talents that have special values
func format() -> Dictionary[String, String]:
	return {}
