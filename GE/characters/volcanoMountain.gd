extends Node2D

const fireBallPath = preload("res://characters/fireball.tscn")

signal playerHit2

var angle_to_target = null
var target: CharacterBody2D = null
var fireCooldown = false
@onready var volvano = $volcanoMountain
@onready var rayCast = $RayCast2D
@onready var reloadTimer = $RayCast2D/ReloadTimer
@onready var playerHitbox = get_parent().get_node("./swordsman").get_hitbox()

func _ready():
	await(get_tree().process_frame)
	$RayCast2D/ReloadTimer.connect("timeout", _on_ReloadTimer_timeout)

func setPlayer(player: CharacterBody2D):
	target = player
	
func getDetectorArea():
	return $IntruderDetector

func _physics_process(delta):
	angle_to_target = global_position.direction_to(target.global_position)
	
	rayCast.set_target_position(angle_to_target)
	
	if (fireCooldown == false && playerDetected()):
		shoot()
		
func shoot():
	var fireball = fireBallPath.instantiate()
	
	fireball.dir = angle_to_target
	fireball.spawnPosition = global_position
	fireball.spawnRotation = rotation
	fireball.velocity = (target.global_position - global_position).normalized() * 200
	fireball.set_player_hitbox(playerHitbox)
	get_parent().add_child(fireball)
	fireball.playerHit.connect(player_hit_by_fireball)	
	fireCooldown = true
	reloadTimer.start()

func _on_ReloadTimer_timeout():
	fireCooldown = false

func player_hit_by_fireball():
	playerHit2.emit()

func playerDetected():
	var playerDetected = $IntruderDetector.get_overlapping_areas()
	if (playerDetected.size() > 0):
		return true
