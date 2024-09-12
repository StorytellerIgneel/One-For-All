class_name Key extends InventoryItem

@export var key_amount: int = 1  # Represents how many keys this instance adds to the player's inventory

func use(player: CharacterBody2D) -> void:
	var total_keys = player.get_total_keys()

	if total_keys == 3:
		print("You have exactly 3 keys!")
		player.open_gate(total_keys)
	elif total_keys > 3:
		print("You have more than 3 keys!")
	else:
		print("You have less than 3 keys.")

#func get_total_keys_from_inventory(player: CharacterBody2D) -> int:
	#var key_count = 0
	## Assuming `player.inventory` is the player's inventory containing items
	#for item in player.inventory.items:
		#if item is Key:
			#key_count += item.key_amount
	#return key_count
