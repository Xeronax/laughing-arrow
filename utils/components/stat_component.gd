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


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	hp_changed.emit()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass
