extends Node2D

@export var output_file_path: String = "res://tilemap_export.png"

func _ready():
	# Get the TileMap node
	var tilemap := $TileMap

	# Create a Node2D as a parent to the TileMap instance
	var tilemap_parent := Node2D.new()

	# Create a viewport and set its size to the size of the TileMap
	var viewport := $Viewport
	#var map_size := tilemap.get_used_rect().size * tilemap.cell_size
	#viewport.size = map_size
	#viewport.clear_mode = Viewport.CLEAR_MODE_ONLY_NEXT_FRAME
	#viewport.render_target_update_mode = Viewport.UPDATE_ONCE

	# Instance the TileMap and add it to the Viewport's scene
	#var tilemap_instance := tilemap.duplicate()
	#tilemap_parent.add_child(tilemap_instance)
	#viewport.add_child(tilemap_parent)

	# Render one frame to update the Viewport texture
	#viewport.render_target_update_mode = Viewport.UPDATE_ONCE
	#yield(viewport, "size_changedd")

	# Create an image from the viewport
	#var image := viewport.get_texture().get_image()
	#image.flip_y()  # Flip the image if necessary

	# Save the image as a PNG file
	#var error := image.save_png(output_file_path)
	#if error == OK:
	#	print("TileMap exported successfully.")
	#else:
	#	print("Error exporting TileMap.")
