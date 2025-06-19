extends GraphEdit

func _ready() -> void:
	for skill in get_children():
		if skill is not GraphNode:
			continue
		skill.button.pressed.connect(func (): rank_up(skill))

func rank_up(s: GraphNode) -> void:
	if s.rank >= s.max_rank:
		return
	s.rank += 1
	s.update()

func refresh() -> void:
	for node in get_children():
		if node is not GraphNode:
			continue
		node.update()
