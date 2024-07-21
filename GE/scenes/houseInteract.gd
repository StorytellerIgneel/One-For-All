extends Area2D

const balloon = preload("res://Dialogues/balloon.tscn")
@export var dialogue_resource: DialogueResource
@export var dialogue_start: String = "start"

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func action() -> void:
	print("Triggered")
	#DialogueManager.show_example_dialogue_balloon(dialogue_resource, dialogue_start)
	var balloon: Node = balloon.instantiate()
	get_tree().current_scene.add_child(balloon)
	balloon.start(dialogue_resource, dialogue_start)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
