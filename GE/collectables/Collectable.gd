extends Area2D

@export var itemRes: InventoryItem

# Might need to change InventoryItem to Inventory but it will cause "ERROR"
func collect(inventory: Inventory):
	inventory.insert(itemRes)
	queue_free()
