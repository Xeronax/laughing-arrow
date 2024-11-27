class_name StatComponent extends Component
## StatComponent implements component behavior to represent stats
##
## Most stats are comprised of three variables the represent the current,
## maximum, and base maximum value of that stat. 

@export var base_max_hp: int
var max_hp: int
var hp: int

@export var base_max_ap: int
var max_ap: int
var ap: int

@export var base_max_mp: int
var max_mp: int
var mp: int

## The Battle Manager starts each battle by creating a turn order that's
## determined by each BattleCharacter's initiative.
@export var initiative: int

signal hp_changed
signal ap_changed
signal mp_changed

func _ready() -> void:
	max_hp = base_max_hp
	max_mp = base_max_mp
	max_ap = base_max_ap

func set_ap(val: int) -> void:
	if(ap == val):
		return
	ap = mini(val, max_ap)
	ap_changed.emit()

func set_mp(val: int) -> void:
	if(mp == val):
		return
	mp = mini(val, max_mp)
	mp_changed.emit()

func set_hp(val: int) -> void:
	if(hp == val):
		return
	hp = mini(val, max_hp)
	hp_changed.emit()
