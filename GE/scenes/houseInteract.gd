extends Area2D

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func action():
	#DialogueManager.show_example_dialogue_balloon(dialogue_resource, dialogue_start)
	Global.trigger_dialogue("res://Dialogues/house.dialogue", "start")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
