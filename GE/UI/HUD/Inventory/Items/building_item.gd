class_name BuildingItem extends InventoryItem

@export var building_amount: int = 1  # Represents how many keys this instance adds to the player's inventory

func use(player: CharacterBody2D) -> void:
	# The building item can be used infinitely
	player.check_building_count()
	
