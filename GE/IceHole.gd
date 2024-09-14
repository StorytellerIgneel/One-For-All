extends Node2D

var steppedOn: bool = false
var radius
var playerHitboxRadius

# Called when the node enters the scene tree for the first time.
func _ready():
	radius = get_radius($CharacterBody2D/IceHoleArea/CollisionShape2D)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var playerDetected = $CharacterBody2D/IceHoleArea.get_overlapping_areas();
	
	if (playerDetected.size() > 0): #player detected
		if (Global.findElement(playerDetected, "player_hitbox")):
			for area in playerDetected:
				if area.name == "player_hitbox":
					playerHitboxRadius = get_radius(area.get_node("CollisionShape2D"))
					if ($CharacterBody2D/IceHoleArea.global_position.distance_to(area.global_position) < 10):
						steppedOn = true
			
	if (steppedOn == true and !Global.findElement(playerDetected, "player_hitbox")):
		print("deleting")
		queue_free()

func get_radius(collision_shape):   
   # Check if the shape is a CircleShape2D
	if collision_shape.shape is CircleShape2D:
		var circle_shape = collision_shape.shape as CircleShape2D
		var radius = circle_shape.radius
		#print("The radius of the circular shape is: ", radius)
		return radius
	else:
		print("The shape is not a CircleShape2D.")
