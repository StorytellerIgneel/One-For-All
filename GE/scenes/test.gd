extends Camera2D

@onready var viewport = get_parent().get_node("SubViewport")

func _ready():
	# Calculate the desired size in pixels
	screenshot()
	
func screenshot():
	await RenderingServer.frame_post_draw

	viewport = get_viewport()
	var img = viewport.get_texture().get_image()
	
	img.save_png("res://resources/screenshots/test.png")
