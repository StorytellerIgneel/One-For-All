extends Area2D



func _physics_process(delta):
	pass
	
func action():
	var chestOpen = Image.load_from_file("res://resources/tilemap/plain/Texture/openedChest.png")
	self.get_parent().get_node("Sprite2D").texture = ImageTexture.create_from_image(chestOpen)
	if get_parent().has_Key == true and Global.findingKey == 3:
		Global.trigger_dialogue("res://Dialogues/Key3.dialogue", "start")
	elif get_parent().has_Key == true and Global.findingKey != 3:
		Global.trigger_dialogue("res://Dialogues/wrongKey.dialogue", "start")
	else: #no key
		Global.trigger_dialogue("res://Dialogues/PlainItemsNoKey.dialogue", "start")
