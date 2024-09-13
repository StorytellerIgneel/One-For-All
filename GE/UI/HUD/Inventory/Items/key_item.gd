class_name Key extends InventoryItem

@export var key_amount: int = 1  # Represents how many keys this instance adds to the player's inventory

func use(player: CharacterBody2D) -> void:
	player.check_key_count()  # Assuming the player has this method

	
