extends Node

const OFFSET: Vector2 = Vector2(0, -7)
const GREEN_HIGHLIGHT: Vector2i = Vector2i(5, 1)
const ORANGE_HIGHLIGHT: Vector2i = Vector2i(2, 7)

var current_scene = null
var camera: Camera2D = null
var map: TileMapLayer = null
var highlight_map: TileMapLayer = null
var ui: CanvasLayer = null
var pathfinding_map: AStarGrid2D = null
var battle_manager: Node2D = null
var mouse_on_ui: bool = false

func _ready() -> void:
	var root = get_tree().get_root()
	current_scene = root.get_child(root.get_child_count() - 1)
	await(current_scene.ready)
	camera = current_scene.camera
	map = current_scene.map
	ui = current_scene.ui
	highlight_map = current_scene.highlight_map
	pathfinding_map = current_scene.layer_holder.map_astar
	battle_manager = current_scene.battle_manager
	
	teleport_character(current_scene.player, 4, 4)
	teleport_character(current_scene.dummy, 13, 4)
	
	var combatants: Array[BattleCharacter] = [current_scene.player, current_scene.dummy]
	current_scene.battle_manager.start_battle(combatants)

func grid_to_global_position(cell: Vector2) -> Vector2: 
	return current_scene.to_global(map.map_to_local(cell))

func teleport_character(character: BattleCharacter, x: int, y: int) -> void: 
	character.global_position = grid_to_global_position(Vector2(x, y))
	character.grid_position = Vector2(x, y)

func grid_to_ui(cell: Vector2) -> Vector2:
	return (grid_to_global_position(cell) - camera.global_position) * camera.zoom + current_scene.get_viewport_rect().size / 2

func highlight_cell(position: Vector2i, color: Vector2i) -> void:
	highlight_map.set_cell(position, 0, color)

func path_to_cell(from: Vector2i, to: Vector2i) -> Array[Vector2i]:
	var path: Array[Vector2i] = []
	for vec in pathfinding_map.get_point_path(from, to):
		if Vector2i(vec/16) == from:
			continue
		var local_point: Vector2i = Vector2i(vec/16)
		path.append(local_point)
	return path

func get_range(grid_position: Vector2i, range: int, _minimum_range: int = 0) -> Array[Vector2i]:
	var explored: Array[Vector2i] = []
	var queue: Array[Vector2i] = [ grid_position ]
	var cells_in_range: Array[Vector2i] = []
	while not queue.is_empty():
		var current_cell: Vector2i = queue.pop_back()
		# Nonwalkable cell check
		var cell_data: TileData = map.get_cell_tile_data(current_cell)
		if cell_data.probability < 1:
			continue
		# Distance check
		var dist: int = abs((grid_position - current_cell).x) + abs((grid_position - current_cell).y)
		if dist > range:
			continue
		# Breadth first search
		if explored.has(current_cell):
			continue
		if current_cell != grid_position:
			cells_in_range.append(current_cell)
		explored.append(current_cell)
		for neighbor in map.get_surrounding_cells(current_cell):
			queue.push_back(neighbor)
	return cells_in_range
