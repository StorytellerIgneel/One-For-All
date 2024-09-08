extends Control

signal opened
signal closed

var isOpen: bool = false

@onready var inventory: Inventory = preload("res://UI/HUD/Inventory/PlayerInventory.tres")
@onready var slots: Array = $NinePatchRect/GridContainer.get_children()
@onready var ItemStackGuiClass = preload("res://UI/HUD/Inventory/itemStackGui.tscn")

func _ready():
	inventory.updated.connect(update)
	update()
	
func update():
	for i in range(min(inventory.slots.size(), slots.size())):
		var inventorySlot: InventorySlot = inventory.slots[i]
		
		if !inventorySlot.item: continue
		
		var itemStackGui: ItemStackGui = slots[i].itemStackGui
		
		if !itemStackGui:
			itemStackGui = ItemStackGuiClass.instantiate()
			
			slots[i].insert(itemStackGui)
		
		itemStackGui.inventorySlot = inventorySlot
		itemStackGui.update()
	
func open():
	visible = true
	isOpen = true
	opened.emit()


func close():
	visible = false
	isOpen = false
	closed.emit()
