extends Area2D

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func action():
	if get_parent().hasKey == true and Global.findingKey == 1:
		Global.findingKey = 2 #finding second key now
		Global.trigger_dialogue("res://Dialogues/Key1.dialogue", "start")
	elif get_parent().has_Key == true and Global.findingKey != 3:
		Global.trigger_dialogue("res://Dialogues/wrongKey.dialogue", "start")
	else: #no key
		Global.trigger_dialogue("res://Dialogues/PlainItemsNoKey.dialogue", "start")
