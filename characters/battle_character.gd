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
signal targeted

var is_turn: bool = false
var moving: bool = false
var reversed: bool = false
var casting: bool = false
var damage_node: PackedScene = preload("res://ui/damage_popups/DamagePopup.tscn")
var movement_cells: Array[Vector2i] = []

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	stats.hp = stats.max_hp
	_reset_resources()

func start_turn() -> void:
	_reset_resources()
	is_turn = true
	turn_starting.emit()
	if(ai_component._enabled if ai_component else false):
		print("Starting ai behavior")
		ai_component.turn_behavior()
	else:
		highlight_movement_range()

func end_turn() -> void:
	movement_cells.clear()
	is_turn = false
	Global.highlight_map.clear()
	turn_ending.emit()

func take_damage(damage_event: DamageEvent) -> void:
	stats.set_hp(stats.hp - damage_event.final_damage)
	sprite_component.Sprite.play("get_hit")
	_create_damage_popup(damage_event.final_damage)

func move(cell: Vector2i) -> void:
	var path: Array[Vector2i] = Global.path_to_cell(self.grid_position, cell)
	if path.size() > stats.mp:
		return
	moving = true
	reversed = cell.x < grid_position.x
	var tween: Tween = get_tree().create_tween()
	if path.is_empty(): 
		return
	sprite_component.animation_player.play("run")
	for point in path:
		stats.set_mp(stats.mp - 1)
		tween.tween_property(self, "global_position", Global.grid_to_global_position(point), 0.5)
	tween.tween_callback(func (): 
		sprite_component.animation_player.play("idle")
		moving = false
		grid_position = cell
		)

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
	tween.tween_property(damage_popup, "position", Vector2(x_component, y_component), .5).set_ease(Tween.EASE_OUT)
	
	Global.ui.add_child(damage_popup)
	damage_popup.position = loc
	label.text = str(damage)
	animation.play("popup")

func _update_movement_range(pos: Vector2i = grid_position) -> void:
	if stats.mp <= 0:
		movement_cells.clear()
		return
	var map_grid: TileMapLayer = Global.map
	movement_cells.clear()
	movement_cells = Global.get_range(grid_position, stats.mp)

func highlight_movement_range() -> void:
	_update_movement_range()
	for cell in movement_cells:
		Global.highlight_cell(cell, Global.GREEN_HIGHLIGHT)
