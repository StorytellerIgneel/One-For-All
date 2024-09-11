extends CharacterBody2D

var speed = 40
var player_chase = false
var player = null

func _physics_process(delta):
	if player_chase:
		position += (player.position - position)/speed
		
		$elite_orc_animation.play("walk")
		
		if(player.position.x - position.x) < 0:
			$elite_orc_animation.flip_h = true
		else:
			$elite_orc_animation.flip_h = false
			
	else:
		$elite_orc_animation.play("idle")

func _on_detection_area_body_entered(body):
	player = body
	player_chase = true


func _on_detection_area_body_exited(body):
	player = null
	player_chase = false
