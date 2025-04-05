class_name StatComponent extends Component
## StatComponent implements component behavior to represent stats
@export var base_hp: int = 50
@export var base_ap: int = 4
@export var base_mp: int = 3

class Stat:
	var base: int = 1
	var flat_bonus: int = 0
	var max: int = 1
	var current: int = 1
	var percent_bonus: float = 0
	func final() -> int:
		return round((base + flat_bonus) * (1 + percent_bonus))

var hp: Stat
var ap: Stat
var mp: Stat
var initiative: Stat
## The Battle Manager starts each battle by creating a turn order that's
## determined by each BattleCharacter's initiative.

signal hp_changed
signal ap_changed
signal mp_changed

func update() -> void:
	for stat: Stat in [hp, ap, mp]:
		stat.max = stat.final()
	initiative.current = initiative.final()

func _ready() -> void:
	hp = Stat.new()
	hp.base = base_hp
	mp = Stat.new()
	mp.base = base_mp
	ap = Stat.new()
	ap.base = base_ap
	initiative = Stat.new()
	update()

func set_ap(val: int) -> void:
	if(ap.current == val):
		return
	ap.current = mini(val, ap.max)
	ap_changed.emit()

func set_mp(val: int) -> void:
	if(mp.current == val):
		return
	mp.current = mini(val, mp.max)
	mp_changed.emit()

func set_hp(val: int) -> void:
	if(hp.current == val):
		return
	hp.current = mini(val, hp.max)
	hp_changed.emit()
