class_name BattleCharacter extends CharacterBody2D

@onready var sprite_component: SpriteComponent = $SpriteComponent
@onready var stats: StatComponent = $StatComponent
@onready var spellbook: Node = $Spellbook
@onready var ai_component: AIComponent = $AIController
@export var player_team: bool = false
@export var target: BattleCharacter
@export var grid_position: Vector2
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

func end_turn() -> void:
	is_turn = false
	turn_ending.emit()

func take_damage(damage_event: DamageEvent) -> void:
	stats.hp -= damage_event.final_damage
	stats.hp_changed.emit()
	_create_damage_popup(damage_event.final_damage)
	print(self, " took ", damage_event.final_damage, " damage.")

func _reset_resources():
	stats.ap = stats.max_ap
	stats.mp = stats.max_mp

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
