class_name BattleCharacter extends CharacterBody2D
## BattleCharacter defines the default behaviors for characters in combat.
##
## Partially, BattleCharacter acts as a holder for a bunch of other components
## and acts as the bridge between things that components can't do on their own.

@onready var sprite_component: SpriteComponent = $SpriteComponent
@onready var stats: Stats = $StatComponent
@onready var hitbox: CollisionShape2D = $CollisionShape2D


@export var spellbook: Array[Resource] = []
@export var player_team: bool = false
@export var ai_component: AIComponent
@export var target: BattleCharacter
@export var grid_position: Vector2i ## Position inside of the game TileMap
@export var character_name: String

var info_bar_scene: PackedScene = preload("res://ui/floating/NamePlate.tscn")
var combat_text_scene: PackedScene = preload("res://ui/popups/CombatTextPopup.tscn")

signal turn_starting
signal turn_ending

enum States {IDLE, CASTING, MOVING, TARGETING, DEAD}

var hovered: bool = false
var info_bar: Control = null
var state: States = States.IDLE
var is_turn: bool = false
var reversed: bool = false ## Orients the character's sprite.
var movement_cells: Array[Vector2i] = [] ## The cells that the player currently has available to move.
var spell_cells: Array[Vector2i] = [] ## If the player is in targeting mode, this array will be populated.

func _ready() -> void:
	input_pickable = true
	await(Global.all_ready)
	info_bar = info_bar_scene.instantiate()
	info_bar.target = self
	Global.ui.add_child(info_bar)
	stats.hp.set_current(stats.hp.max)
	_reset_resources()

func set_grid_position(pos: Vector2i) -> void:
	Global.pathfinding_map.set_point_solid(grid_position, false)
	grid_position = pos
	Global.pathfinding_map.set_point_solid(pos, true)

func start_turn() -> void:
	_reset_resources()
	is_turn = true
	state = States.IDLE
	Global.battle_manager.turn_starting.emit(self)
	if(ai_component):
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
	stats.hp.set_current(stats.hp.current - event.final_damage)
	sprite_component.Sprite.play("get_hit")
	var damage_popup: CombatText = combat_text_scene.instantiate()
	damage_popup.event = event
	damage_popup.source = self
	Global.ui.add_child(damage_popup)

func move(cell: Vector2i) -> void:
	var path: Array[Vector2i] = Global.path_to_cell(self.grid_position, cell)
	if path.size() > stats.mp.current:
		return
	state = States.MOVING
	sprite_component.face_direction(cell)
	var tween: Tween = get_tree().create_tween()
	if path.is_empty(): 
		return
	sprite_component.animation_player.play("run")
	for point in path:
		stats.mp.set_current(stats.mp.current - 1)
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
	stats.ap.set_current(stats.ap.max)
	stats.mp.set_current(stats.mp.max)

func update_movement_range(_pos: Vector2i = grid_position) -> void:
	if stats.mp.current <= 0:
		movement_cells.clear()
		return
	movement_cells.clear()
	movement_cells = Global.get_range(grid_position, stats.mp.current).filter(func(cell): 
		if Global.pathfinding_map.is_point_solid(cell):
			return false
		if Global.pathfinding_map.get_point_path(grid_position, cell).size() - 1 > stats.mp.current:
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
	_set_hovered(true)

func _mouse_exit() -> void:
	_set_hovered(false)

func _unhandled_input(event: InputEvent) -> void:
	if event is not InputEventMouseButton:
		return
	if not hovered:
		return
	if Global.current_controller.state in [BattleCharacter.States.TARGETING]:
		return
	Global.set_current_target(self)
	_set_hovered(true)

func _set_hovered(h: bool) -> void:
	hovered = h
	if Global.current_target == self:
		info_bar.set_visible(true)
	else:
		info_bar.set_visible(h)

func add_spell(ability: Resource) -> void:
	spellbook.append(ability)
	if ability is Spell:
		ability.caster = self
		turn_starting.connect(ability.tick_cooldown)
	Global.ui.get_node("SpellBar").refresh_spells()
