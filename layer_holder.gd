extends Node2D

@onready var highlight_map: TileMapLayer = $Highlights
@onready var map: TileMapLayer = $Ground

@export var current_controller: BattleCharacter 

var tile_size: int = 16
var grid_color: Color = Color('black', 0.25)
var grid_width: float = 0.35
var map_width: int = 20
var map_height: int = 15
var hovered_tile: Vector2i
var map_astar: AStarGrid2D = AStarGrid2D.new()

func _ready() -> void:
	map_astar.set_cell_size(Vector2i(16, 16))
	map_astar.set_region(map.get_used_rect())
	map_astar.update()

func _draw() -> void:
	for x in range(map_width + 1):
		var starting_point: Vector2 = Vector2(x * tile_size, 0)
		var ending_point: Vector2 = Vector2(x * tile_size, map_height * tile_size)
		draw_line(starting_point, ending_point, grid_color, grid_width)
		
	for y in range(map_height + 1):
		var starting_point: Vector2 = Vector2(0, y * tile_size)
		var ending_point: Vector2 = Vector2(map_width * tile_size, y * tile_size)
		draw_line(starting_point, ending_point, grid_color, grid_width)

func _process(delta: float) -> void:
	if current_controller.stats.mp <= 0:
		return
	var mouse_pos = get_local_mouse_position()
	var hovered_tile = map.local_to_map(mouse_pos)
	if not current_controller.movement_cells.has(hovered_tile):
		return
	var path: Array[Vector2] = []
	for vec in  map_astar.get_point_path(current_controller.grid_position, hovered_tile):
		var local_point: Vector2 = vec/16
		path.append(local_point)
	print(path)

func _unhandled_input(event: InputEvent) -> void:
	if event is not InputEventMouseButton:
		return
	if not current_controller.is_turn:
		return
	if not current_controller.movement_cells.has(hovered_tile):
		return
	current_controller.move(hovered_tile)
