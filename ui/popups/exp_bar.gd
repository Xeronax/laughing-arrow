extends Control

@onready var progress_bar: TextureProgressBar = $TextureProgressBar
@onready var exp_label: RichTextLabel = $RichTextLabel
@onready var current_level_label: RichTextLabel = $CurrentLevel
@onready var next_level_label: RichTextLabel = $NextLevel

var queue: Array[int] = []
var busy: bool = false

func _ready() -> void:
	set_modulate(Color(1, 1, 1, 0))
	progress_bar.value = 0
	Global.exp_changed.connect(enqueue)

func enqueue(gain: int) -> void:
	queue.append(gain)
	if not busy:
		display_gain(queue.pop_front())

func display_gain(exp_gained: int) -> void:
	busy = true
	exp_label.text = "EXP +" + str(exp_gained)
	var tween: Tween = get_tree().create_tween()
	tween.tween_property(self, "modulate", Color(1, 1, 1, 1), 0.5) 
	tween.tween_property(progress_bar, "value", progress_bar.value + exp_gained, 1)
	tween.tween_callback(func():
		if progress_bar.value >= progress_bar.max_value:
			var next_level: int = next_level_label.text.to_int() + 1
			current_level_label.text = next_level_label.text
			next_level_label.text = str(next_level)
			progress_bar.value = 0
			progress_bar.max_value = int(ceil(progress_bar.max_value * 1.25))
		if not queue.is_empty():
			display_gain(queue.pop_front())
			return
		else:
			await get_tree().create_timer(2.5).timeout
			get_tree().create_tween().tween_property(self, "modulate", Color(1, 1, 1, 0), 0.5)
			busy = false
			)
