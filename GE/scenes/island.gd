extends Node

var NextLevel: bool = false

@onready var pause_menu = $CanvasLayer/InputSettings

var game_paused = false
#var inWater_cooldown = false
#var outWater_cooldown = false

@onready var viewport = get_parent().get_node("SubViewport1")
@onready var camera = $SubViewport/Camera2D
@onready var tilemap = $IslandTileMap
@onready var water_region = $IslandTileMap/WaterRegion
@onready var player = $soldierV2
@onready var oxygenLevel = $OxygenLevel/ProgressBar
@onready var Player = $knight


# Called when the node enters the scene tree for the first time.
func _ready():
	Global.currentTilemap = $IslandTileMap
	player.set_water_region(water_region)
	
	#Global.trigger_dialogue("res://Dialogues/NewGame.dialogue", "start")
	
	player.InWaterRegion.connect(inWater)
	player.OutWaterRegion.connect(outWater)
	
	initialize_camera_limit()

func _physics_process(delta):
	if (Global.nextLevelBool == true):
		await LoadManager.load_scene("res://scenes/beach.tscn")
		Global.nextLevelBool = false
	
	#var actionables = $soldierV2/player_hitbox.get_overlapping_areas()
	#
	#if actionables.size() > 1:
		#if (Global.findElement(actionables, "WaterRegion")):
			#if (inWater_cooldown == false):
				#inWater_cooldown = true
				#$inWaterTimer.start()
				#inWater()
	#else: #in cooldown
		#if (outWater_cooldown == false):
			#outWater()
			#outWater_cooldown = true
			#$outWaterTimer.start()
		
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
			
# Inventory function
#func _on_hurt_box_area_entered(area):
	#if area.has_method("collect"):
		#area.collect()
		

func initialize_camera_limit():
	$soldierV2/PlayerCamera.limit_right = $IslandTileMap.get_used_rect().size.x * 16
	$soldierV2/PlayerCamera.limit_bottom = $IslandTileMap.get_used_rect().size.y * 16

func _on_inventory_gui_closed():
	get_tree().paused = false

func _on_inventory_gui_opened():
	get_tree().paused = true	

func _on_setting_menu_closed():
	get_tree().paused = false
	
func _on_setting_menu_opened():
	get_tree().paused = false
