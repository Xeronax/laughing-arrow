extends Node2D

@onready var player: BattleCharacter = $Player
@onready var dummy: BattleCharacter = $Dummy
@onready var dummy2: BattleCharacter = $Dummy2
@onready var map: TileMapLayer = $LayerHolder/Ground
@onready var battle_manager: Node2D = $BattleManager
@onready var ui: CanvasLayer = $UI
@onready var camera: Camera2D = $Camera2D
@onready var highlight_map: TileMapLayer = $LayerHolder/Highlights
@onready var layer_holder: Node2D = $LayerHolder
