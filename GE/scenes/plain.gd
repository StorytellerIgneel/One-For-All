extends Node

var NextLevel: bool = false

@onready var dialogue_start_teleport: String = "teleport"
@onready var pause_menu = $CanvasLayer/InputSettings

@export var date_time: DateTime = DateTime.new()

@export var inventory: Inventory

var game_paused = false
var health = 0

@onready var viewport = get_parent().get_node("SubViewport1")
@onready var camera = $SubViewport/Camera2D
@onready var tilemap = $TileMap
@onready var water_region = $TileMap/WaterRegion
@onready var player = $soldierV2

# Called when the node enters the scene tree for the first time.
func _ready():
	Global.currentTilemap = $PlainTileMap
	$Tree10.hasKey = true
	$Chest2.hasKey = true
	Global.trigger_dialogue("res://Dialogues/plain.dialogue", "start")
	
	if date_time == null:
		date_time = DateTime.new()  # Ensure it's not null
		
	#print("TimeManager ready with date_time initialized.")
	
	TimeManager.connect("updated", Callable(self, "_on_time_system_updated"))
	initialize_camera_limit()
	
#func _on_time_system_updated(date_time: DateTime) -> void:
	## Handle time updates (e.g., update UI or trigger events based on time)
	#print("Time updated: ", date_time.days, " days, ", date_time.hours, " hours, ", date_time.minutes, " minutes")

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
		#get_tree().change_scene_to_file("res://scenes/winterfell.tscn")
		await LoadManager.load_scene("res://scenes/winterfell.tscn")
		
	#if event.is_action_pressed("Interact"):
		#var actionables = $soldierV2/player_hitbox.get_overlapping_areas()
		#if actionables.size() > 1:
			#if (Global.findElement(actionables, "PortalArea")):
				#Global.trigger_dialogue("res://Dialogues/teleport.dialogue", "teleport")
				#if (State.teleport == true):
					#for area in actionables:
						#if area.get_parent().name == "Portal1":
							#player.global_position = $Portal2.global_position
						#elif area.get_parent().name == "Portal2":
							#player.global_position = $Portal1.global_position
					#State.teleport = false
				##logic to tp
		#else:
			#pass
	if event.is_action_pressed("Interact"):
		var actionables = $soldierV2/player_hitbox.get_overlapping_areas()
	
	# Check if the player is overlapping with any areas
		if actionables.size() > 1:
		
		# Check if the area contains a PortalArea and if the player has 3 keyds
			if Global.findElement(actionables, "PortalArea"):
			
				# Check inventory key amount
				if player.inventory.get_total_keys() < 1:
					print("You need a key to teleport.")
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
		
		# get_tree().change_scene_to_file("res://scenes/winterfell.tscn")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var actionables = $soldierV2/player_hitbox.get_overlapping_areas()
	
	if (State.teleport == true):
		for area in actionables:
			if area.get_parent().name == "Portal1":
				player.global_position = $Portal2.global_position
			elif area.get_parent().name == "Portal2":
				player.global_position = $Portal1.global_position
				get_tree().change_scene_to_file("res://scenes/winterfell.tscn")
		State.teleport = false
		return
	
	if (Global.nextLevelBool == true):
		await LoadManager.load_scene("res://scenes/winterfell.tscn")
		Global.nextLevelBool = false
	##print(State.teleport)

func initialize_camera_limit():
	$soldierV2/PlayerCamera.limit_left = 0
	$soldierV2/PlayerCamera.limit_top = -192
	$soldierV2/PlayerCamera.limit_right = 1152
	$soldierV2/PlayerCamera.limit_bottom = 648
