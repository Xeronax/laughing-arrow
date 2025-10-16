class_name CombatText extends Control

@onready var label: RichTextLabel = $Label
@onready var animation: AnimationPlayer = $AnimationPlayer

var event: DamageEvent = null
var source: BattleCharacter = null

func _ready() -> void:
	var tween: Tween = get_tree().create_tween()
	global_position = Global.grid_to_ui(source.grid_position) 
	var x_component: float = global_position.x + randf_range(-30, 30)
	var y_component: float = global_position.y - randf_range(35, 60)
	tween.tween_property(self, "position", Vector2(x_component, y_component), .5).set_ease(Tween.EASE_OUT)
	label.text = "[shake rate=20.0 level=5 connected=1][color=WHITE][font='res://assets/BebasNeue-Regular.ttf'][font_size=32]" + str(event.final_damage)
	if event.critical_strike: label.text += "!"
	animation.play("popup")
