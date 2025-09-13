class_name SpriteComponent extends Component

@export var Sprite: AnimatedSprite2D
@export var animation_player: AnimationPlayer
@export var target_size: int
@export var face_right_by_default: bool = false

@onready var portrait: Texture2D = Sprite.sprite_frames.get_frame_texture('idle', 0)

signal hit_frame

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if(target_size == 0):
		return
	var texture_size: Vector2 = Sprite.sprite_frames.get_frame_texture('idle', 0).get_size()
	Sprite.set_scale(Vector2((target_size / texture_size.x), (target_size / texture_size.y)))
	idle()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if not target_node:
		pass
	Sprite.flip_h = target_node.reversed

func face_direction(cell: Vector2i) -> void:
	if cell.x < target_node.grid_position.x:
		if face_right_by_default:
			target_node.reversed = true
		else:
			target_node.reversed = false
	else:
		if face_right_by_default:
			target_node.reversed = false
		else:
			target_node.reversed = true

func idle() -> void:
	animation_player.play("idle")

func hit() -> void:
	hit_frame.emit()
