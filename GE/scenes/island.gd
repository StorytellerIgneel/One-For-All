extends Node

var NextLevel: bool = false

@onready var pause_menu = $CanvasLayer/InputSettings

var game_paused = false

@onready var viewport = get_parent().get_node("SubViewport1")
@onready var camera = $SubViewport/Camera2D
@onready var tilemap = $TileMap
@onready var water_region = $TileMap/WaterRegion
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
		await LoadManager.load_scene("res://scenes/beach.tscn")

		# Below is the Original Code
		# get_tree().change_scene_to_file("res://scenes/beach.tscn")
		
	if event.is_action_pressed("Interact"):
		var actionables = $soldierV2/player_hitbox.get_overlapping_areas()
	
	# Check if the player is overlapping with any areas
		if actionables.size() > 1:
		
		# Check if the area contains a PortalArea and if the player has 3 keys
			if Global.findElement(actionables, "PortalArea"):
			
				# Check inventory key amount
				if player.inventory.get_total_keys() < 3:
					print("You need 3 keys to teleport.")
					return  # Exit if the player doesn't have 3 keys
			
				Global.trigger_dialogue("res://Dialogues/teleport.dialogue", "teleport")

			# If teleport is triggered, execute teleport logic
				if State.teleport == true:
					for area in actionables:
						if area.get_parent().name == "Portal1":
							player.global_position = $Portal2.global_position
						elif area.get_parent().name == "Portal2":
							player.global_position = $Portal1.global_position
							print("Teleporting to the next scene...")
							get_tree().change_scene_to_file("res://scenes/winterfell.tscn")
					State.teleport = false
					return
		
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
	print($soldierV2/PlayerCamera.limit_right)


func _on_inventory_gui_closed():
	get_tree().paused = false

func _on_inventory_gui_opened():
	get_tree().paused = true	

func _on_setting_menu_closed():
	get_tree().paused = false
	
func _on_setting_menu_opened():
	get_tree().paused = false
