extends Area2D

var currentMap
var triggerDialogue

func _ready():
	print(currentMap)
	
func action():
	currentMap = Global.currentTilemap.name
	if (currentMap == "BeachTileMap"):
		triggerDialogue = "res://Dialogues/beachPuzzle.dialogue"
	elif (currentMap == "PlainTileMap"):
		triggerDialogue = "res://Dialogues/plainPuzzle.dialogue"
	elif (currentMap == "WinterfellTileMap"):
		triggerDialogue = "res://Dialogues/winterfellPuzzle.dialogue"
	elif (currentMap == "VolcanoTileMap"):
		triggerDialogue = "res://Dialogues/volcanoPuzzle.dialogue"
	
	Global.trigger_dialogue(triggerDialogue, "start")
