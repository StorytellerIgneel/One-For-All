extends Node

var NextLevel: bool = false

const balloon_scene = preload("res://Dialogues/balloon.tscn")
@export var dialogue_resource_path: String = "res://Dialogues/NewGame.dialogue"
@export var dialogue_start: String = "tutorial"

var dialogue_resource: DialogueResource
var balloon: Control

# Called when the node enters the scene tree for the first time.
func _ready():
	# Load the dialogue resource directly from the path
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
