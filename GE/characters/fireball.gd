extends CharacterBody2D

signal playerHit

const BULLETSPEED = 100.0
var dir: Vector2
var spawnPosition:Vector2
var spawnRotation:float
var playerHitbox: Area2D

func set_player_hitbox(hitbox: Area2D):
	playerHitbox = hitbox
	
func _ready():
	#print(velocity)
	global_position = spawnPosition
	global_rotation = spawnRotation
	
func _physics_process(delta):
	velocity = dir * BULLETSPEED
	move_and_slide()

	var actionables = $actionable_finder.get_overlapping_areas()
	if actionables.size() > 1:
		if (actionables[1] == playerHitbox):
			playerHit.emit()
			queue_free()
