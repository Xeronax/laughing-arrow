extends Control

@onready var progress_bar: TextureProgressBar = $TextureProgressBar
@onready var exp_label: RichTextLabel = $RichTextLabel
@onready var current_level_label: RichTextLabel = $CurrentLevel
@onready var next_level_label: RichTextLabel = $NextLevel

func _ready() -> void:
	set_modulate(Color(1, 1, 1, 0))


func display_gain(exp_gained: int) -> void:
	current_level_label.text = str(Global.current_controller.level)
	next_level_label.text = str(Global.current_controller.level + 1)
	progress_bar.value = Global.current_controller.exp
	progress_bar.max_value = Global.current_controller.exp_to_next_level
	var tween: Tween = get_tree().create_tween()
	exp_label.text = "EXP +" + str(exp_gained)
	tween.tween_property(self, "modulate", Color(1, 1, 1, 1), 0.5) 
	tween.tween_property(progress_bar, "value", progress_bar.value + exp_gained, 1)
	tween.tween_callback(func(): 
		await get_tree().create_timer(1.5).timeout
		var fade_out: Tween = get_tree().create_tween()
		fade_out.tween_property(self, "modulate", Color(1, 1, 1, 0), 0.5))
