extends Area2D

var currentMap
var triggerDialogue

func _ready():
	if (currentMap == "BeachTileMap"):
		triggerDialogue = "beach"
	elif (currentMap == "PlainTileMap"):
		triggerDialogue = "plain"
	elif (currentMap == "WinterfellTileMap"):
		triggerDialogue = "winterfell"
	elif (currentMap == "VolcanoTileMap"):
		triggerDialogue = "volcano"
	
func action():
	currentMap = Global.currentTilemap.name
	Global.trigger_dialogue("res://instructions.dialogue", triggerDialogue)
