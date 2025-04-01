extends Node2D

@onready var highlight_map: TileMapLayer = $Highlights
@onready var map: TileMapLayer = $Ground

var tile_size: int = 16
var grid_color: Color = Color('black', 0.25)
var grid_width: float = 0.35
var map_width: int = 20
var map_height: int = 15
var map_astar: AStarGrid2D = AStarGrid2D.new()
var hovered_tile: Vector2i 

func _ready() -> void:
	map_astar.set_cell_size(Vector2i(16, 16))
	map_astar.set_region(map.get_used_rect())
	map_astar.set_diagonal_mode(AStarGrid2D.DIAGONAL_MODE_NEVER)
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

func _process(_delta: float) -> void:
	_current_controller_highlighting()

func _current_controller_highlighting() -> void:
	if not Global.current_controller.is_turn:
		return
	var current_controller: BattleCharacter = Global.current_controller
	var cell_currently_hovered: Vector2i = map.local_to_map(get_local_mouse_position())
	highlight_map.erase_cell(hovered_tile)
	if current_controller.state == BattleCharacter.States.IDLE:
		current_controller.highlight_movement_range()
	if current_controller.state == BattleCharacter.States.TARGETING:
		current_controller.highlight_spell_range()
	hovered_tile = cell_currently_hovered
	if not Global.mouse_on_ui:
		Global.highlight_cell(hovered_tile, Global.WHITE)
	else:
		highlight_map.erase_cell(hovered_tile)

func _unhandled_input(event: InputEvent) -> void:
	if event is not InputEventMouseButton:
		return
	if not Global.current_controller.is_turn:
		return
	if not event.is_pressed():
		return
	if Global.current_controller.state in [Global.current_controller.States.IDLE]:
		if not Global.current_controller.movement_cells.has(hovered_tile):
			return
		var character_on_cell = Global.get_character(hovered_tile)
		if character_on_cell:
			Global.current_controller.target = character_on_cell
			return
		highlight_map.clear()
		Global.current_controller.move(hovered_tile)
	if Global.current_controller.state in [Global.current_controller.States.TARGETING]:
		highlight_map.clear()
		Global.target_selected.emit([hovered_tile])
