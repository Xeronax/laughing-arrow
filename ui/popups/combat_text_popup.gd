class_name CombatText extends Control

@onready var label: RichTextLabel = $Label
@onready var animation: AnimationPlayer = $AnimationPlayer

enum TextType { DAMAGE, STATUS, LEVEL }

var params: Array[Variant] = []
var source: BattleCharacter = null
var type: TextType

func _ready() -> void:
	var tween: Tween = get_tree().create_tween()
	match type:
		TextType.DAMAGE: 
			global_position = Global.grid_to_ui(source.grid_position) 
			var x_component: float = global_position.x + randf_range(-30, 30)
			var y_component: float = global_position.y - randf_range(35, 60)
			tween.tween_property(self, "position", Vector2(x_component, y_component), .5).set_ease(Tween.EASE_OUT)
			label.text = "[shake rate=20.0 level=5 connected=1][color=ORANGE][font='res://assets/BebasNeue-Regular.ttf'][font_size=32]" + str(params[0])
			animation.play("popup")
		TextType.LEVEL:
			var view_size: Vector2 = get_viewport_rect().size 
			global_position = get_viewport_rect().size/2 - Vector2(25, 0)
			var y_component: float = global_position.y - randf_range(35, 60)
			tween.tween_property(self, "position", Vector2(global_position.x, y_component), 3).set_ease(Tween.EASE_OUT)
			animation.play("level_up")
			label.text = "[font_size=52]Level Up!\n[color=YELLOW]" + str(source.level)
