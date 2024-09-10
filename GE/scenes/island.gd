extends Node

var NextLevel: bool = false

const balloon_scene = preload("res://Dialogues/balloon.tscn")
@onready var dialogue_resource_path: String = "res://Dialogues/NewGame.dialogue"
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
@onready var oxygenLevel = $OxygenLevel/ProgressBar


# Called when the node enters the scene tree for the first time.
func _ready():
	# Load the dialogue resource directly from the pat
	dialogue_resource = load(dialogue_resource_path) as DialogueResource
	player.set_water_region(water_region)
	
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


func _unhandled_input(event):
	if event.is_action_pressed("pause"):
		game_paused = !game_paused
		
		if game_paused:
			Engine.time_scale = 0
			pause_menu.visible = true
		else:
			Engine.time_scale = 1
			pause_menu.visible = false
			
		get_tree().root.get_viewport().set_input_as_handled()
	
	if event.is_action_pressed("NextMap"):
		# Added Loading scene, added by Sia
		await LoadManager.load_scene("NextMap")

		# Below is the Original Code
		# get_tree().change_scene_to_file("res://scenes/beach.tscn")
		
	# YAP TESTING SCENE, DONT TOUCH
	if event.is_action_pressed("YAP_TESTING_SCENE"):
		get_tree().change_scene_to_file("res://scenes/yap_testing_scene.tscn")
	
		
func inWater():
	oxygenLevel.value = oxygenLevel.value + 10
	if (oxygenLevel.value == 100):
		player.health = 0;

func outWater():
	if(oxygenLevel.value > 0):
		oxygenLevel.value = oxygenLevel.value - 10
		if (oxygenLevel.value < 0):
			oxygenLevel.value = 0
			
func _on_hurt_box_area_entered(area):
	if area.has_method("collect"):
		area.collect()
		

func initialize_camera_limit():
	$soldierV2/PlayerCamera.limit_right = $TileMap.get_used_rect().size.x * 16
	$soldierV2/PlayerCamera.limit_bottom = $TileMap.get_used_rect().size.y * 16
	print($soldierV2/PlayerCamera.limit_right)


func _on_inventory_gui_closed():
	get_tree().paused = false

func _on_inventory_gui_opened():
	get_tree().paused = true
