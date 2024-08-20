extends CharacterBody2D

var vel = Vector2(0, 0)
var speed = 200

func _physics_process(delta):
	var collision_info = move_and_collide(vel.normalized() * delta * speed)
