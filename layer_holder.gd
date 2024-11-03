extends Node2D

var tile_size: int = 16
var grid_color: Color = Color('black', 0.25)
var grid_width: float = 0.35
var map_width: int = 20
var map_height: int = 15

func _draw() -> void:
	for x in range(map_width + 1):
		var starting_point: Vector2 = Vector2(x * tile_size, 0)
		var ending_point: Vector2 = Vector2(x * tile_size, map_height * tile_size)
		draw_line(starting_point, ending_point, grid_color, grid_width)
		
	for y in range(map_height + 1):
		var starting_point: Vector2 = Vector2(0, y * tile_size)
		var ending_point: Vector2 = Vector2(map_width * tile_size, y * tile_size)
		draw_line(starting_point, ending_point, grid_color, grid_width)
