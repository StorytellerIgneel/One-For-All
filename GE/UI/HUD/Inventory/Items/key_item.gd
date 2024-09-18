class_name Key extends InventoryItem

@export var key_amount: int = 1  # Represents how many keys this instance adds to the player's inventory

func use(player: CharacterBody2D) -> void:
	
	if player.has_method("add_key_to_inventory"):
		# Add the key to the player's inventory
		for i in range(key_amount):
			player.add_key_to_inventory()
	else:
		print("Player does not have add_key_to_inventory method")

	
