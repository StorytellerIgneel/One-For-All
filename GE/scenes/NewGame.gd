extends Area2D

const balloon_scene = preload("res://Dialogues/balloon.tscn")
@export var dialogue_resource: DialogueResource
@export var dialogue_start: String = "start"

# Called when the node enters the scene tree for the first time.
func _ready():
	#var balloon_instance = balloon_scene.instantiate()
	#get_tree().current_scene.add_child(balloon_instance)
	#balloon_instance.start(dialogue_resource, dialogue_start)
	pass # Replace with function body.
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
