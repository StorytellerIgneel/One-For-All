extends Resource

class_name Inventory

signal updated
signal use_item

@export var slots: Array[InventorySlot]

func insert(item: InventoryItem):
	if item is Key:
		
		var key_count = get_total_keys()

		# Stop collecting keys if the count is 3 or more
		if key_count >= 3:
			print("You already have 3 keys. Can't collect more!")
			return

	var itemSlots = slots.filter(func(slot): return slot.item == item )
	
	if !itemSlots.is_empty():
		itemSlots[0].amount += 1
	else:
		var emptySlots = slots.filter(func(slot): return slot.item == null)
		
		if !emptySlots.is_empty():
			emptySlots[0].item = item
			emptySlots[0].amount = 1			
			
	updated.emit()

# Method to get the total number of keys in the inventory
func get_total_keys() -> int:
	var key_count = 0
	for slot in slots:
		if slot.item is Key:
			key_count += slot.amount  # Add the number of keys in this slot
	return key_count
			
func removeSlot(inventorySlot: InventorySlot):
	var index = slots.find(inventorySlot)
	
	if index < 0: return
	
	remove_at_index(index)
	
func remove_at_index(index: int) -> void:
	slots[index] = InventorySlot.new()
	
	updated.emit()
	
func insertSlot(index: int, inventorySlot: InventorySlot):
	slots[index] = inventorySlot
	
	updated.emit()

func use_item_at_index(index: int) -> void:
	if index < 0 || index >= slots.size() || !slots[index].item: return
	
	var slot = slots[index]
	use_item.emit(slot.item)
	
	if slot.amount > 1:
		slot.amount -= 1
		updated.emit()
		return
	
	remove_at_index(index)
			
	updated.emit()
	
func has_one_building_item() -> bool:
	for slot in slots:
		if slot.item is BuildingItem and slot.amount == 1:
			return true
	return false

