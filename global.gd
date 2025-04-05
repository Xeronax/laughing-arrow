extends Node

class Highlight:
	var tilemap_id: int
	var coordinates: Vector2i
	func _init(id: int, coords: Vector2i) -> void:
		tilemap_id = id
		coordinates = coords

var GREEN: Highlight = Highlight.new(0, Vector2i(5, 1))
var ORANGE: Highlight = Highlight.new(0, Vector2i(2, 7))
var WHITE: Highlight = Highlight.new(1, Vector2i(9, 5))

var current_scene = null
var camera: Camera2D = null
var map: TileMapLayer = null
var highlight_map: TileMapLayer = null
var ui: CanvasLayer = null
var pathfinding_map: AStarGrid2D = null
var battle_manager: Node2D = null
var mouse_on_ui: bool = false
var current_controller: BattleCharacter = null
var current_target: BattleCharacter = null

signal current_target_changed
signal all_ready
signal target_selected(targets)
signal current_controller_changed(char)

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
	
	all_ready.emit()
	
	teleport_character(current_scene.player, 4, 4)
	teleport_character(current_scene.dummy, 13, 4)
	
	ui.get_node("ActionBar").switch_target(current_scene.player)
	
	var combatants: Array[BattleCharacter] = [current_scene.player, current_scene.dummy]
	current_scene.battle_manager.start_battle(combatants)

func set_ui_children(node: Control):
	node.mouse_entered.connect(func (): mouse_on_ui = true)
	node.mouse_exited.connect(func (): mouse_on_ui = false)
	for child in node.get_children():
		set_ui_children(child)

func set_current_controller(t: BattleCharacter) -> void:
	current_controller = t
	current_controller_changed.emit(t)

func set_current_target(t: BattleCharacter) -> void:
	current_target = t
	current_target_changed.emit()

func get_character(cell: Vector2i) -> BattleCharacter:
	for character: BattleCharacter in battle_manager.characters:
		if character.grid_position == cell:
			return character
	return null

func teleport_character(character: BattleCharacter, x: int, y: int) -> void: 
	character.global_position = grid_to_global_position(Vector2(x, y))
	character.grid_position = Vector2(x, y)

func grid_to_global_position(cell: Vector2) -> Vector2: 
	return current_scene.to_global(map.map_to_local(cell))

func global_to_ui(cell: Vector2) -> Vector2:
	return (cell - camera.global_position) * camera.zoom + current_scene.get_viewport_rect().size / 2 

func grid_to_ui(cell: Vector2) -> Vector2:
	return global_to_ui(grid_to_global_position(cell))

func highlight_cell(position: Vector2i, color: Highlight) -> void:
	highlight_map.set_cell(position, color.tilemap_id, color.coordinates)

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

func get_dist(from: Vector2i, to: Vector2i) -> int:
	return pathfinding_map.get_point_path(from, to).size()
