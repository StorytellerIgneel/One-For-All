extends Node

var NextLevel: bool = false

const balloon_scene = preload("res://Dialogues/balloon.tscn")
@onready var dialogue_resource_path: String = "res://Dialogues/plain.dialogue"
@onready var dialogue_start: String = "start"
@onready var pause_menu = $CanvasLayer/InputSettings

var game_paused = false
var dialogue_resource: DialogueResource
var balloon: CanvasLayer

@onready var viewport = get_parent().get_node("SubViewport1")
@onready var camera = $SubViewport/Camera2D
@onready var tilemap = $TileMap
@onready var water_region = $TileMap/WaterRegion
@onready var player = $soldierV2

# Called when the node enters the scene tree for the first time.
func _ready():
	# Load the dialogue resource directly from the pat
	dialogue_resource = load(dialogue_resource_path) as DialogueResource
	
	if dialogue_resource == null:
		print("Error: Failed to load dialogue resource.")
		return
	
	balloon = balloon_scene.instantiate()
	get_tree().current_scene.add_child(balloon)
	# Check if the balloon instance has the expected method
	if balloon.has_method("start"):
		balloon.start(dialogue_resource, dialogue_start)
	else:
		print("Error: 'start' method not found in balloon instance.")
	
	player.InWaterRegion.connect(inWater)
	player.OutWaterRegion.connect(outWater)
	
	initialize_camera_limit()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func initialize_camera_limit():
	$soldierV2/PlayerCamera.limit_right = $TileMap.get_used_rect().size.x * 16
	$soldierV2/PlayerCamera.limit_bottom = $TileMap.get_used_rect().size.y * 16
	print($soldierV2/PlayerCamera.limit_right)
