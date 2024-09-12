extends Node

var NextLevel: bool = false

const balloon_scene = preload("res://Dialogues/balloon.tscn")

var game_paused = false
var dialogue_resource: DialogueResource
var balloon: CanvasLayer


var player_current_attack = false
var slime_current_attack = false

func trigger_dialogue (dialogue_resource_path, dialogue_start):
	dialogue_resource = load(dialogue_resource_path) as DialogueResource
	
	if dialogue_resource == null:
		print("Error: Failed to load dialogue resource.")
		return
	
	balloon = balloon_scene.instantiate()
	get_tree().current_scene.add_child(balloon)
	# Check if the balloon instance has the expected method
	if balloon.has_method("start"):
		balloon.start(dialogue_resource, dialogue_start)
	else:
		print("Error: 'start' method not found in balloon instance.")
	
func nextLevel(nextScene):
	trigger_dialogue ("res://Dialogues/teleport.dialogue", "start")
	if (State.NextLevel == true):
		get_tree().change_scene_to_file(nextScene)
		State.NextLevel = false
