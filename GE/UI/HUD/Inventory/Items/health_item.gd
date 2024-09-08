class_name HealthItem extends InventoryItem

@export var health_increase: int = 5

# this is pass to the amount param in soldier_v2 script
func use(player: CharacterBody2D) -> void:
	player.increase_health(health_increase)
