extends Area2D

const balloon = preload("res://Dialogues/balloon.tscn")
@export var dialogue_resource: DialogueResource
@export var dialogue_start: String = "start"

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func action() -> void:
	#DialogueManager.show_example_dialogue_balloon(dialogue_resource, dialogue_start)
	var balloon: Node = balloon.instantiate()
	get_tree().current_scene.add_child(balloon)
	balloon.start(dialogue_resource, dialogue_start)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_button_pressed():
	get_tree().change_scene_to_file("res://UI/Setting/KeyBinding/input_settings.tscn")
