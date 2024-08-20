extends CharacterBody2D


const BULLETSPEED = 1000.0
var dir:float
var spawnPosition:Vector2
var spawnRotation:float

func _ready():
	#print(velocity)
	global_position = spawnPosition
	global_rotation = spawnRotation
	
func _physics_process(delta):
	#velocity = Vector2().rotated(dir)*delta
	print(velocity)
	move_and_slide()
