extends AIComponent

var lance: SpellComponent

func _ready() -> void:
	super()
	await(setup_done)
	lance = character.spellbook.get_node("DeathLance")

func turn_behavior() -> void:
	lance.cast()
	await(move_ready)
	character.end_turn()
