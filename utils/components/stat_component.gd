class_name StatComponent extends Component

@export var initiative: int
@export var max_hp: int
@export var attack: int
@export var max_ap: int
@export var max_mp: int

var ap: int
var mp: int
var hp: int

signal hp_changed
signal ap_changed
signal mp_changed

func set_ap(val: int) -> void:
	if(ap == val):
		return
	ap = val
	ap_changed.emit()

func set_mp(val: int) -> void:
	if(mp == val):
		return
	mp = val
	mp_changed.emit()

func set_hp(val: int) -> void:
	if(hp == val):
		return
	hp = val
	hp_changed.emit()
