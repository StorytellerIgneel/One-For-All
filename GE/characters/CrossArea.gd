extends Area2D



func _physics_process(delta):
	pass
	
func action():
	if get_parent().hasKey == true and Global.findingKey == 2:
		Global.trigger_dialogue("res://Dialogues/Key2.dialogue", "start")
	elif get_parent().has_Key == true and Global.findingKey != 3:
		Global.trigger_dialogue("res://Dialogues/wrongKey.dialogue", "start")
	else: #no key
		Global.trigger_dialogue("res://Dialogues/PlainItemsNoKey.dialogue", "start")
