class_name BattleCharacter extends CharacterBody2D

@onready var sprite_component: SpriteComponent = $SpriteComponent
@onready var stats: StatComponent = $StatComponent
@onready var spellbook: Node = $Spellbook
@onready var ai_component: AIComponent = $AIController
@export var player_team: bool = false
@export var target: BattleCharacter
@export var grid_position: Vector2i
@export var hitbox: CollisionShape2D

signal turn_starting
signal turn_ending

var is_turn: bool = false
var moving: bool = false
var reversed: bool = false
var casting: bool = false
var damage_node: PackedScene = preload("res://ui/damage_popups/DamagePopup.tscn")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	stats.hp = stats.max_hp
	_reset_resources()

func start_turn() -> void:
	_reset_resources()
	is_turn = true
	turn_starting.emit()
	print(self, " starting turn")
	if(ai_component):
		print("Starting ai behavior")
		ai_component.turn_behavior()
	else:
		_highlight_movement_range()

func end_turn() -> void:
	is_turn = false
	Global.highlight_map.clear()
	turn_ending.emit()

func take_damage(damage_event: DamageEvent) -> void:
	stats.set_hp(stats.hp - damage_event.final_damage)
	sprite_component.Sprite.play("get_hit")
	_create_damage_popup(damage_event.final_damage)

func _reset_resources():
	stats.set_ap(stats.max_ap)
	stats.set_mp(stats.max_mp)

func _create_damage_popup(damage: int) -> void:
	var damage_popup: Control = damage_node.instantiate()
	var loc: Vector2 = Global.grid_to_ui(grid_position)
	var animation: AnimationPlayer = damage_popup.get_node("AnimationPlayer")
	var label: Label = damage_popup.get_node("Label")
	
	var tween: Tween = get_tree().create_tween()
	var x_component: float = loc.x + randf_range(-30, 30)
	var y_component: float = loc.y - randf_range(35, 60)
	tween.tween_property(damage_popup, "position", Vector2(x_component, y_component), .5)
	
	Global.ui.add_child(damage_popup)
	damage_popup.position = loc
	label.text = str(damage)
	animation.play("popup")

func _highlight_movement_range() -> void:
	if stats.mp <= 0:
		return
	var movement_range: int = stats.mp
	var cells_to_highlight: Array[Vector2i] = []
	var highlight_map: TileMapLayer = Global.highlight_map
	
	for dist in range(1, movement_range):
		var up: Vector2i = grid_position + Vector2i(0, -dist)
		var down: Vector2i = grid_position + Vector2i(0, dist)
		var left: Vector2i = grid_position + Vector2i(-dist, 0)
		var right: Vector2i = grid_position + Vector2i(dist, 0)
		for direction in [up, down, left, right]:
			cells_to_highlight.append_array(
				highlight_map.get_surrounding_cells(direction).filter(func (cell):
					if cells_to_highlight.has(cell):
						return false
					if cell == grid_position:
						return false
					return true
					)
				)
	for cell in cells_to_highlight:
		Global.highlight_cell(cell, Global.GREEN_HIGHLIGHT)
