class_name BattleCharacter extends CharacterBody2D
## BattleCharacter defines the default behaviors for characters in combat.
##
## Partially, BattleCharacter acts as a holder for a bunch of other components
## and acts as the bridge between things that components can't do on their own.

@onready var sprite_component: SpriteComponent = $SpriteComponent
@onready var stats: StatComponent = $StatComponent
@onready var spellbook: Array = $Spellbook.get_children()
@onready var ai_component: AIComponent = $AIController

@export var player_team: bool = false
@export var target: BattleCharacter
@export var grid_position: Vector2i ## Position inside of the game TileMap
@export var hitbox: CollisionShape2D 

signal turn_starting
signal turn_ending
signal targeted

enum States {IDLE, CASTING, MOVING, TARGETING, DEAD}

var state: States = States.IDLE

var damage_node: PackedScene = preload("res://ui/damage_popups/DamagePopup.tscn")
var is_turn: bool = false
var reversed: bool = false ## Orients the character's sprite.
var movement_cells: Array[Vector2i] = [] ## The cells that the player currently has available to move.
var spell_cells: Array[Vector2i] = [] ## If the player is in targeting mode, this array will be populated.

func _ready() -> void:
	input_pickable = true
	if not ai_component:
		Global.current_controller = self
	for spell: Spell in spellbook:
		spell.caster = self
	stats.set_hp(stats.max_hp)
	_reset_resources()

func set_grid_position(pos: Vector2i) -> void:
	Global.pathfinding_map.set_point_solid(grid_position, false)
	grid_position = pos
	Global.pathfinding_map.set_point_solid(pos, true)

func start_turn() -> void:
	_reset_resources()
	is_turn = true
	state = States.IDLE
	turn_starting.emit()
	if(ai_component._enabled if ai_component else false):
		print("Starting ai behavior")
		ai_component.turn_behavior()
	else:
		highlight_movement_range()

func end_turn() -> void:
	movement_cells.clear()
	is_turn = false
	state = States.IDLE
	Global.highlight_map.clear()
	turn_ending.emit()

func take_damage(event: DamageEvent) -> void:
	stats.set_hp(stats.hp - event.final_damage)
	sprite_component.Sprite.play("get_hit")
	_create_damage_popup(event.final_damage)

func move(cell: Vector2i) -> void:
	var path: Array[Vector2i] = Global.path_to_cell(self.grid_position, cell)
	if path.size() > stats.mp:
		return
	state = States.MOVING
	reversed = cell.x < grid_position.x
	var tween: Tween = get_tree().create_tween()
	if path.is_empty(): 
		return
	sprite_component.animation_player.play("run")
	for point in path:
		stats.set_mp(stats.mp - 1)
		tween.tween_property(self, "global_position", Global.grid_to_global_position(point), 0.5)
		set_grid_position(point)
	tween.tween_callback(func (): 
		sprite_component.animation_player.play("idle")
		state = States.IDLE
		set_grid_position(cell)
		if ai_component:
			ai_component.move_ready.emit()
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

func update_movement_range(pos: Vector2i = grid_position) -> void:
	if stats.mp <= 0:
		movement_cells.clear()
		return
	var map_grid: TileMapLayer = Global.map
	movement_cells.clear()
	movement_cells = Global.get_range(grid_position, stats.mp).filter(func(cell): 
		if Global.pathfinding_map.is_point_solid(cell):
			return false
		if Global.pathfinding_map.get_point_path(grid_position, cell).size() - 1 > stats.mp:
			return false
		return true)

func highlight_movement_range() -> void:
	update_movement_range()
	for cell in movement_cells:
		Global.highlight_cell(cell, Global.GREEN)

func highlight_spell_range() -> void:
	for cell in spell_cells:
		Global.highlight_cell(cell, Global.ORANGE)

func _mouse_enter() -> void:
	print("Entered!")
