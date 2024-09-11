extends Node2D



# Called when the node enters the scene tree for the first time.
func _ready():
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var playerDetected = ($"Goddess Statue/HealingArea".get_overlapping_areas());
	
	if (playerDetected.size() > 0): #player detected
		
		if (playerDetected[0].name == "ActionableFinder"):
			playerDetected[0].get_parent().get_parent().health = 100
