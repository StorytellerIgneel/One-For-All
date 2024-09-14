extends Area2D

var currentMap = Global.currentTilemap.name
var nextMap

func _ready():
	if (currentMap == "IslandTileMap"):
		nextMap = "res://scenes/beach.tscn"
	elif (currentMap == "BeachTileMap"):
		nextMap = "res://scenes/plain.tscn"
	elif (currentMap == "PlainTileMap"):
		nextMap = "res://scenes/winterfell.tscn"
	elif (currentMap == "WinterfellTileMap"):
		nextMap = "res://scenes/volcano.tscn"
		

func _physics_process(delta):
	if (State.NextLevel == true):
		get_tree().change_scene_to_file(nextMap)
		State.NextLevel = false
	
func action():
	Global.trigger_dialogue("res://Dialogues/NextLevel.dialogue", "start")
