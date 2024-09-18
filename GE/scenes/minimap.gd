extends SubViewport

@onready var camera = $Camera2D
@onready var player = get_node("../../../soldierV2")

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	camera.position = player.position
	pass
