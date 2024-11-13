extends Node

const OFFSET: Vector2 = Vector2(0, -7)
const GREEN_HIGHLIGHT: Vector2i = Vector2i(5, 1)
const ORANGE_HIGHLIGHT: Vector2i = Vector2i(2, 7)

var current_scene = null
var camera: Camera2D = null
var map: TileMapLayer = null
var highlight_map: TileMapLayer = null
var ui: CanvasLayer = null


func _ready() -> void:
	var root = get_tree().get_root()
	current_scene = root.get_child(root.get_child_count() - 1)
	await(current_scene.ready)
	camera = current_scene.camera
	map = current_scene.map
	ui = current_scene.ui
	highlight_map = current_scene.highlight_map
	
	teleport_character(current_scene.player, 4, 4)
	teleport_character(current_scene.dummy, 13, 4)
	
	current_scene.battle_manager.start_battle([current_scene.player, current_scene.dummy])

func grid_to_global_position(cell: Vector2) -> Vector2: 
	return current_scene.to_global(map.map_to_local(cell))

func teleport_character(character: BattleCharacter, x: int, y: int) -> void: 
	character.global_position = grid_to_global_position(Vector2(x, y))
	character.grid_position = Vector2(x, y)

func grid_to_ui(cell: Vector2) -> Vector2:
	return (grid_to_global_position(cell) - camera.global_position) * camera.zoom + current_scene.get_viewport_rect().size / 2

func highlight_cell(position: Vector2i, color: Vector2i) -> void:
	print("Highlighting ", position)
	highlight_map.set_cell(position, 0, color)
