extends Node

var NextLevel: bool = false

@onready var pause_menu = $CanvasLayer/InputSettings

var game_paused = false

var freeze_cooldown = false
var fire_region: Array[Area2D]
var in_fire_region = false

@onready var freeze_level = $CanvasLayer/FreezeLevel
@onready var viewport = get_parent().get_node("SubViewport1")
@onready var camera = $SubViewport/Camera2D
@onready var tilemap = $TileMap
@onready var player = $soldierV2

# Called when the node enters the scene tree for the first time.
func _ready():
	$FreezeTimer.connect("timeout", _on_FreezeTimer_timeout)
	fire_region.clear()
	for child in get_children():
		for i in range(1, 9):
		# Get the node by name using the format "Fire" + i
			var node_name = "Fire" + str(i)
			var fire = get_node(node_name)
			
			for fireChild in fire.get_children():
				if fireChild is Area2D:
					fire_region.append(fireChild)
	fire_region = fire_region.slice(0, 8)
	player.set_fire_region(fire_region)
	# Load the dialogue resource directly from the path
	
	Global.trigger_dialogue("res://Dialogues/winterfell.dialogue", "winterfell_start")
	
	player.InFireRegion.connect(inFireRegion)
	player.OutFireRegion.connect(OutFireRegion)

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
		get_tree().change_scene_to_file("res://scenes/volcano.tscn")
		  
func _physics_process(delta):
	if (freeze_cooldown == false && !in_fire_region):
		freeze_cooldown = true
		freeze_level.value += 10
		if (freeze_level.value == 100):
			player.health = 0
		$FreezeTimer.start()
	
	var actionables = $soldierV2/player_hitbox.get_overlapping_areas()
	if actionables.size() > 1:
		if (actionables[1] == $TileMap/Ice):
			player.friction = 100
	else:
		player.friction = 1000
		

func _on_FreezeTimer_timeout():
	freeze_cooldown = false

func inFireRegion():
	in_fire_region = true
	if (freeze_level.value > 0):
		freeze_level.value -= 10
		if (freeze_level.value < 0):
			freeze_level.value = 0

func OutFireRegion():
	in_fire_region = false
