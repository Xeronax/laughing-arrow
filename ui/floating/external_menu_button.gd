extends TextureButton

@export var button_texture: Texture2D
@export var keybind: String
@export var popup: Node

func _ready() -> void:
	Global.set_ui_children(self)
	set_texture_normal(button_texture)
	if not popup: 
		return
	pressed.connect(func(): 
		popup.set_visible(!popup.visible)
		for tab in popup.get_children():
			if not tab.has_method("update"):
				continue
			tab.update()
		)
