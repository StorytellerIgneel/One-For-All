extends Node

var NextLevel: bool = false

@onready var dialogue_start_teleport: String = "teleport"
@onready var pause_menu = $CanvasLayer/InputSettings

@export var date_time: DateTime = DateTime.new()

var game_paused = false

@onready var viewport = get_parent().get_node("SubViewport1")
@onready var camera = $SubViewport/Camera2D
@onready var tilemap = $TileMap
@onready var water_region = $TileMap/WaterRegion
@onready var player = $soldierV2

# Called when the node enters the scene tree for the first time.
func _ready():
	Global.trigger_dialogue("res://Dialogues/volcano.dialogue", "volcano_start")
	
	initialize_camera_limit()
	
	if date_time == null:
		date_time = DateTime.new()  # Ensure it's not null
		
	#print("TimeManager ready with date_time initialized.")
	
	TimeManager.connect("updated", Callable(self, "_on_time_system_updated"))
	
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
		
	if event.is_action_pressed("Interact"):
		var actionables = $soldierV2/player_hitbox.get_overlapping_areas()
		if actionables.size() > 1:
			if (actionables[1] == $TileMap/Portal1 or actionables[1] == $TileMap/Portal2):
				Global.trigger_dialogue("res://Dialogues/teleport.dialogue", "teleport")
				#logic to tp
		else:
			pass
		
		# get_tree().change_scene_to_file("res://scenes/winterfell.tscn")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	print(State.teleport)
	pass

func initialize_camera_limit():
	$soldierV2/PlayerCamera.limit_right = $TileMap.get_used_rect().size.x * 16
	$soldierV2/PlayerCamera.limit_bottom = $TileMap.get_used_rect().size.y * 16
	print($soldierV2/PlayerCamera.limit_right)
