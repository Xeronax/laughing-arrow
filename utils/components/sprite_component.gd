class_name SpriteComponent extends Component

@export var Sprite: AnimatedSprite2D
@export var animation_player: AnimationPlayer
@export var target_size: int

@onready var portrait: Texture2D = Sprite.sprite_frames.get_frame_texture('idle', 0)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if(target_size == 0):
		return
	var texture_size: Vector2 = Sprite.sprite_frames.get_frame_texture('idle', 0).get_size()
	Sprite.set_scale(Vector2((target_size / texture_size.x), (target_size / texture_size.y)))

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if not target_node:
		pass
	var current_animation = animate()
	Sprite.flip_h = target_node.reversed
	if current_animation == '':
		pass
	Sprite.play(current_animation)


func animate() -> String:
	if(Sprite.is_playing()):
		return ''
	if target_node.moving:
		return 'run'
	return 'idle'
