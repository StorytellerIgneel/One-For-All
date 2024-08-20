extends Node2D

const fireBallPath = preload("res://characters/fireball.tscn")

var target: Node2D = null
@onready var volvano = $volcanoMountain
@onready var rayCast = $RayCast2D
@onready var reloadTimer = $RayCast2D/ReloadTimer
@onready var player: CharacterBody2D

func _ready():
	pass

func _physics_process(delta):
	var angle_to_target = global_position.direction_to(target.global_position)
	rayCast.set_target_position(angle_to_target)
	
	if (reloadTimer.is_stopped()):
		shoot()
		
func shoot():
	rayCast.enabled = false
	var fireball = fireBallPath.instantiate()
	
	get_parent().add_child(fireball)
	fireball.global_position = global_position
	fireball.global_rotation = global_rotation

	reloadTimer.start()

func _on_ReloadTimer_timeout():
	rayCast.enabled = true
