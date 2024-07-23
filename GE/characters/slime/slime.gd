extends CharacterBody2D

var speed = 70
var player_chase = false
var player = null

func _physics_process(delta):
	if player_chase:
		position += (player.position - position)/speed
		
		$slime_animation.play("walk")
		
		if(player.position.x - position.x) < 0:
			$slime_animation.flip_h = true
		else:
			$slime_animation.flip_h = false
			
	else:
		$slime_animation.play("idle")



func _on_detection_area_body_entered(body):
	player = body
	player_chase = true


func _on_detection_area_body_exited(body):
	player = null
	player_chase = false
