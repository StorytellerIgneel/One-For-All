extends Camera2D

@export var tile_size: Vector2 = Vector2(32, 32)  # Size of a tile in pixels
@export var tiles_visible: Vector2 = Vector2(10, 20)  # Number of tiles to be visible

func _ready():
	# Calculate the desired size in pixels
	var desired_width = tile_size.x * tiles_visible.x
	var desired_height = tile_size.y * tiles_visible.y

	# Get the viewport size
	var viewport_size = get_viewport().size

	# Calculate the zoom level
	zoom = Vector2(viewport_size.x / desired_width, viewport_size.y / desired_height)
