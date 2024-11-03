class_name Component extends Node

@export var target_node: Node

func _ready() -> void:
	await(target_node.ready)
	_target_node_ready()
 
func _target_node_ready() -> void:
	pass
