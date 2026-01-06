extends AspectRatioContainer

@onready var icon = $Icon
@onready var stacks = $Icon/Stacks

var status: Status

func set_status(s: Status) -> void:
	if s != status:
		icon.texture = s.icon
		status = s
		status.target.status_removed.connect(func(stat): 
			if stat == status:
				queue_free())
	update()


func update() -> void:
	stacks.text = str(status.current_stacks)
	if status.current_stacks > 1:
		stacks.set_visible(true)
	else:
		stacks.set_visible(false)
