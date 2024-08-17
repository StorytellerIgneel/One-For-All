extends Camera2D

@onready var viewport = get_parent().get_node("SubViewprt")

func _ready():
	# Calculate the desired size in pixels
	screenshot()
	
func screenshot():
	await RenderingServer.frame_post_draw

	viewport = get_viewport()
	#viewport.size = Vector2(1920, 1080)  # Set to desired width and height
	#viewport.size_override = true

	var img = viewport.get_texture().get_image()
	
	img.save_png("res://resources/screenshots/test2.png")
