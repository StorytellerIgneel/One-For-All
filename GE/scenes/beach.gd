extends Node

var NextLevel: bool = false

@onready var pause_menu = $CanvasLayer/InputSettings

var game_paused = false

@onready var viewport = get_parent().get_node("SubViewport1")
@onready var tilemap = $TileMap
@onready var muddyRegion = $TileMap/muddyRegion
@onready var player = $soldierV2

# Called when the node enters the scene tree for the first time.
func _ready():
	Global.currentTilemap = $BeachTileMap
	# Load the dialogue resource directly from the path
	player.set_muddy_region(muddyRegion)
	
	#Global.trigger_dialogue("res://Dialogues/beach.dialogue", "beach_start")

	initialize_camera_limit()
	
	TimeManager.connect("updated", Callable(self, "_on_time_system_updated"))

	#print("DateTime at scene start: ", TimeManager.date_time)


func _on_time_system_updated(date_time: DateTime) -> void:
	pass
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
		await LoadManager.load_scene("NextMap")
		
		get_tree().change_scene_to_file("res://plain.tscn")
		
func initialize_camera_limit():
	$soldierV2/PlayerCamera.limit_right = $BeachTileMap.get_used_rect().size.x * 16
	$soldierV2/PlayerCamera.limit_bottom = $BeachTileMap.get_used_rect().size.y * 16
	print($soldierV2/PlayerCamera.limit_right)
