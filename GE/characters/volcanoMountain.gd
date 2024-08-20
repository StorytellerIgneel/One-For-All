extends Node2D

const fireBallPath = preload("res://characters/fireball.tscn")

var target: CharacterBody2D = null
var fireCooldown = false
@onready var volvano = $volcanoMountain
@onready var rayCast = $RayCast2D
@onready var reloadTimer = $RayCast2D/ReloadTimer

func _ready():
	await(get_tree().process_frame)
	$RayCast2D/ReloadTimer.connect("timeout", _on_ReloadTimer_timeout)

func setPlayer(player: CharacterBody2D):
	target = player

func _physics_process(delta):
	var angle_to_target = global_position.direction_to(target.global_position)
	rayCast.set_target_position(angle_to_target)
	
	if (fireCooldown == false):
		shoot()
		
func shoot():
	var fireball = fireBallPath.instantiate()
	
	fireball.dir = rotation
	fireball.spawnPosition = global_position
	fireball.spawnRotation = rotation
	fireball.velocity = (target.global_position - global_position).normalized() * 200
	get_parent().add_child(fireball)
	
	fireCooldown = true
	reloadTimer.start()

func _on_ReloadTimer_timeout():
	print("No cooldown")
	fireCooldown = false
