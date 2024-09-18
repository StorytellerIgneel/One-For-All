extends Node

@onready var pause_menu = $CanvasLayer/InputSettings

var game_paused = false

@onready var viewport = get_parent().get_node("SubViewport1")
@onready var tilemap = $BeachTileMap
@onready var muddyRegion = $BeachTileMap/muddyRegion
@onready var player = $knight
@onready var oxygenLevel = $OxygenLevel/ProgressBar

# Called when the node enters the scene tree for the first time.
func _ready():
	Global.currentTilemap = $BeachTileMap
	# Load the dialogue resource directly from the path
	#player.set_muddy_region(muddyRegion)
	
	player.set_water_region($BeachTileMap/waterRegion)
	player.set_muddy_region($BeachTileMap/muddyRegion)
	Global.trigger_dialogue("res://Dialogues/beach.dialogue", "beach_start")

	initialize_camera_limit()
	
	TimeManager.connect("updated", Callable(self, "_on_time_system_updated"))
	player.InWaterRegion.connect(inWater)
	player.OutWaterRegion.connect(outWater)

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
		
func initialize_camera_limit():
	$knight/PlayerCamera.limit_right = $BeachTileMap.get_used_rect().size.x * 16
	$knight/PlayerCamera.limit_bottom = $BeachTileMap.get_used_rect().size.y * 16
	print($knight/PlayerCamera.limit_right)

func _physics_process(delta):
	if (Global.nextLevelBool == true):
		await LoadManager.load_scene("res://scenes/plain.tscn")
		Global.nextLevelBool = false
	
	var actionables = player.get_node("player_hitbox").get_overlapping_areas()
	
	if actionables.size() > 1:
		if (Global.findElement(actionables, "muddyRegion")):
			player.friction = 100

func inWater():
	oxygenLevel.value = oxygenLevel.value + 10
	if (oxygenLevel.value == 100):
		player.health = 0;

func outWater():
	if(oxygenLevel.value > 0):
		oxygenLevel.value = oxygenLevel.value - 10
		if (oxygenLevel.value < 0):
			oxygenLevel.value = 0
			
