extends CharacterBody2D

const fireBallPath = preload("res://characters/fireball.tscn")

func _physics_process(delta):
	if (Input.is_action_just_pressed("Interact")):
		$Shooter.look_at(Vector2(0,0))
		shoot()
	
	
func shoot():
	var fireball = fireBallPath.instantiate()
	
	get_parent().add_child(fireball)
	print($Shooter/Marker2D.global_position)
	fireball.position = $Shooter/Marker2D.position
	fireball.velocity = get_global_mouse_position() - fireball.position
