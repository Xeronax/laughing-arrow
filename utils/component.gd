class_name Component extends Node
## Components latch onto a target_node providing a reference to variables 
## this node cares about.

@export var target_node: Node ## Node that the component cares about.

func _ready() -> void:
	await(target_node.ready)
	_target_node_ready()
 
## Abstract function that waits for the target_node to be ready for behavior.
func _target_node_ready() -> void:
	pass
