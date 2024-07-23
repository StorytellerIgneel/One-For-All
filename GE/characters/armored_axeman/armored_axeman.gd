extends CharacterBody2D

var speed = 40
var player_chase = false
var player = null

func _physics_process(delta):
	if player_chase:
		position += (player.position - position)/speed
		
		$armored_axeman_animation.play("walk")
		
		if(player.position.x - position.x) < 0:
			$armored_axeman_animation.flip_h = true
		else:
			$armored_axeman_animation.flip_h = false
			
	else:
		$armored_axeman_animation.play("idle")

func _on_detection_area_body_entered(body):
	player = body
	player_chase = true


func _on_detection_area_body_exited(body):
	player = null
	player_chase = false
