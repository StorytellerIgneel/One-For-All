extends Area2D

@export var inventory: Inventory

@onready var player = $soldierV2

func _physics_process(delta):
	pass
	
func action():
	var chestOpen = Image.load_from_file("res://resources/tilemap/plain/Texture/openedChest.png")
	self.get_parent().get_node("Sprite2D").texture = ImageTexture.create_from_image(chestOpen)

# Debug prints for the key conditions
	print("has_Key:", get_parent().has_Key)
	print("Global.findingKey:", Global.findingKey)
	
	# Player has the key and it's the correct key
	if get_parent().has_Key == true and Global.findingKey == 3:
		Global.trigger_dialogue("res://Dialogues/Key3.dialogue", "start")
		
			# Insert additional functionality below the 'if' statement
		var key_item = Key.new()  # Assuming Key is a subclass of InventoryItem
		key_item.key_type = Global.findingKey  # Set the key type
		
		# Insert the key into the player's inventory
		if player.inventory.get_total_keys() < 3:
			player.inventory.insert(key_item)
			print("Correct key used. Key added to the player's inventory!")
		else:
			print("Player already has the maximum number of keys.")
	
	# Player has a key but it's the wrong key
	elif get_parent().has_Key == true and Global.findingKey != 3:
		Global.trigger_dialogue("res://Dialogues/wrongKey.dialogue", "start")
	
	# Player has no key
	else:
		Global.trigger_dialogue("res://Dialogues/PlainItemsNoKey.dialogue", "start")
