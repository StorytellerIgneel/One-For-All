extends Node

var NextLevel: bool = false

@onready var pause_menu = $CanvasLayer/InputSettings

var fireball = load("res://characters/fireball.tscn")
var game_paused = false
var boulders: Array[Node]


@onready var viewport = get_parent().get_node("SubViewport1")
@onready var camera = $SubViewport/Camera2D
@onready var tilemap = $TileMap
@onready var player = $soldierV2
@onready var shooters = $volcanoShooters

# Called when the node enters the scene tree for the first time.
func _ready():
	Global.currentTilemap = $VolcanoTileMap
	for child in get_children():
		for i in range(1, 5):
		# Get the node by name using the format "Fire" + i
			var node_name = "Boulder" + str(i)
			var boulder = get_node(node_name)
			boulders.append(boulder)
			
	boulders = boulders.slice(0, 4)
	print(boulders)
	
	#Global.trigger_dialogue("res://Dialogues/volcano.dialogue", "volcano_start")
	# Load the dialogue resource directly from the pat

	shooters.playerHit2.connect(player_hit_by_fireball)
	shooters.target = player
	#initialize_camera_limit()

func _unhandled_input(event):
	if event.is_action_pressed("pause"):
		game_paused = !game_paused
		
		if game_paused:
			Engine.time_scale = 0
			pause_menu.visible = true
		else:
			Engine.time_scale = 1
			pause_menu.visible = false
			
		get_tree().root.get_viewport().set_input_as_handled()
		
	if event.is_action_pressed(("Interact")):
		var actionables = $soldierV2/player_hitbox.get_overlapping_areas()
		if actionables.size() > 1:
			for boulder in boulders:
				# Check if the second element in the 'actionables' array matches the boulder's Area2D node
				if actionables[1] == boulder.get_node("boulderArea"):
					var boulder_name = boulder.name  # Get the name of the boulder
					var last_char = boulder_name.substr(boulder_name.length() - 1, 1)  # Extract the last character
					var boulder_no = int(last_char)  # Convert the last character to an integer
					# Move the boulder by 2 units (you may want to specify a direction, e.g., x or y)
					var direction = "up"  if (boulder_no % 2 == 0) else "down"

					boulder.position += Vector2(16, 0)  # Adjust to move in the desired direction (e.g., right)	
					clear_tiles_in_range(boulder.position, direction, 7)

func initialize_camera_limit():
	$soldierV2/PlayerCamera.limit_right = $TileMap.get_used_rect().size.x * 32
	$soldierV2/PlayerCamera.limit_bottom = $TileMap.get_used_rect().size.y * 32

# Function to clear tiles either up or down along the Y axis
func clear_tiles_in_range(start_pos: Vector2, direction: String, num_tiles: int):
	
	var step_size = 16  # Each tile is spaced 16 pixels apart
	var tilemap_pos = $OverlappingLava.local_to_map(start_pos)  # Convert world position to tilemap coordinates
	print(tilemap_pos)
	var tile_pos
	# Loop to clear the tiles in the range
	for i in range(num_tiles):
		var offset_y = i * step_size
		if direction == "down":
			tile_pos = tilemap_pos +  $OverlappingLava.local_to_map(Vector2i(0, offset_y))  # Going down, increase the y-coordinate
		elif direction == "up":
			tile_pos = tilemap_pos -  $OverlappingLava.local_to_map(Vector2i(0, offset_y))  # Going up, decrease the y-coordinate
		
		# Remove the tile at the calculated position
		remove_tile(tile_pos)

# Helper function to remove a tile
func remove_tile(tilemap_pos: Vector2):
	if $OverlappingLava.get_cell_tile_data(0, tilemap_pos, -1) != null:
		$OverlappingLava.set_cell(0, tilemap_pos, -1)  # Remove the tile
		
		print("Tile removed at position: ", tilemap_pos)
	else:
		print("No tile to remove at position: ", tilemap_pos)		
		#xample usage when boulder reaches (984, 40)

func player_hit_by_fireball():
	player.health -= 10	
