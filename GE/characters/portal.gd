extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	pass
	#var playerDetected = ($CharacterBody2D/IceHoleArea.get_overlapping_areas());
	#
	#if (playerDetected.size() > 0): #player detected
		#if (Global.findElement(playerDetected, "player_hitbox")):
			#for area in playerDetected:
				#if area.name == "player_hitbox":
					#playerHitboxRadius = get_radius(area.get_node("CollisionShape2D"))
					#if ($CharacterBody2D/IceHoleArea.global_position.distance_to(area.global_position) < 10):
						#steppedOn = true
	#pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
