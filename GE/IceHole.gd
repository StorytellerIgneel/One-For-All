extends Node2D

var steppedOn: bool = false
var radius
var playerHitboxRadius

# Called when the node enters the scene tree for the first time.
func _ready():
	radius = get_radius($CharacterBody2D/IceHoleArea/CollisionShape2D)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var playerDetected = ($CharacterBody2D/IceHoleArea.get_overlapping_areas());
	#print(playerDetected.size())
	#print(playerDetected)
	
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

func circle_area(radius: float) -> float:
	return PI * pow(radius, 2)

func overlap_area(r1: float, r2: float, d: float) -> float:
	if d >= r1 + r2:
		return 0  # No overlap, the circles are too far apart.
	
	if d <= abs(r1 - r2):
		# One circle is completely within the other
		return circle_area(min(r1, r2))
	# Calculate the overlap area using the formula for two intersecting circles
	var angle1 = clamp((d * d + r1 * r1 - r2 * r2) / (2 * d * r1), -1.0, 1.0)
	var angle2 = clamp((d * d + r2 * r2 - r1 * r1) / (2 * d * r2), -1.0, 1.0)
	
	var part1 = r1 * r1 * acos(angle1)
	var part2 = r2 * r2 * acos(angle2)
	var part3 = 0.5 * sqrt(max((-d + r1 + r2) * (d + r1 - r2) * (d - r1 + r2) * (d + r1 + r2), 0))
	
	return part1 + part2 - part3


func is_overlap_50_percent_or_more(r1: float, r2: float, d: float) -> bool:
	print(d)
	var total_area = circle_area(r1) + circle_area(r2)
	var overlapping_area = overlap_area(r1, r2, d)
	var overlap_percentage = overlapping_area / total_area
	print("Overlap Percentage: ", overlap_percentage * 100, "%")
	
	return overlap_percentage >= 0.5

func get_radius(collision_shape):   
   # Check if the shape is a CircleShape2D
	if collision_shape.shape is CircleShape2D:
		var circle_shape = collision_shape.shape as CircleShape2D
		var radius = circle_shape.radius
		#print("The radius of the circular shape is: ", radius)
		return radius
	else:
		print("The shape is not a CircleShape2D.")
