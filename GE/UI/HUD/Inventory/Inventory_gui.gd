extends Control

signal opened
signal closed

var isOpen: bool = false

@onready var Inventory: inventory = preload("res://UI/HUD/Inventory/PlayerInventory.tres")
#@onready var slots: Array = $NinePatchRect/GridContainer.get_children()

#func _ready():
	#update()
	
#func update():
	#for i in range(min(Inventory.items.size(), slots.size())):
		#slots[i].update(Inventory.items[i])
	
func open():
	visible = true
	isOpen = true
	opened.emit()


func close():
	visible = false
	isOpen = false
	closed.emit()
