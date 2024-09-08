extends Resource

class_name InventoryItem

@export var name: String = ""
@export var texture: Texture2D
@export var maxAmountPerStack: int

func use(player: CharacterBody2D) -> void:
	pass
