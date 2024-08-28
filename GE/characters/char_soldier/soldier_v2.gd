extends CharacterBody2D

signal InWaterRegion
signal OutWaterRegion

var enemy_in_atk_range = false
var enemy_attack_cooldown = true
var inWater_cooldown = false
var outWater_cooldown = false
var health = 100
var player_alive = true
var attack_ip = false

@onready var _anim = $AnimatedSprite2D
@onready var actionable_finder = $Direction/ActionableFinder

const maxSpeed: int = 100
const accel:int = 10000
const friction:int = 1000

var inputAxis = Vector2.ZERO
var water_region: Area2D

func set_water_region(region: Area2D):
	water_region = region
	print(water_region)

func _ready():
	$inWaterTimer.connect("timeout", _on_inWaterTimer_timeout)
	$outWaterTimer.connect("timeout", _on_outWaterTimer_timeout)
	_anim.play("soldier_idle")
	pass

func _physics_process(delta):
	if(not State.is_dialogue_active):
		player_movement(delta)
		mc_animate()
		check_interact()
	check_environment()
	enemy_attack()
	attack()
	
	if health <= 0:
		player_alive = false  # add end screen
		health = 0
		print("player has been killed")
		self.queue_free()
	pass
	
func check_interact():
	if Input.is_action_just_pressed("Interact"):
		var actionables = actionable_finder.get_overlapping_areas()
		if actionables.size() > 0:
			State.is_dialogue_active = true
			var actionable = actionables[0]
			actionable.action()
	State.is_dialogue_active = false
	return

func check_environment():
	var actionables = actionable_finder.get_overlapping_areas()
	if actionables.size() > 0:
		if (actionables[0] == water_region):
			if (inWater_cooldown == false):
				print("InWater")
				InWaterRegion.emit()
				inWater_cooldown = true
				$inWaterTimer.start()
	else: #section for cooling all level down
		if (outWater_cooldown == false):
			OutWaterRegion.emit()
			outWater_cooldown = true
			$outWaterTimer.start()
	return

func _on_inWaterTimer_timeout():
	inWater_cooldown = false

func _on_outWaterTimer_timeout():
	outWater_cooldown = false
	
func get_input():
	inputAxis.x = int(Input.is_action_pressed("toRight")) - int(Input.is_action_pressed("toLeft"))
	inputAxis.y = int(Input.is_action_pressed("toDown")) - int(Input.is_action_pressed("toUp"))
	return inputAxis.normalized()#set values as normalised [0, +1, or -1]
	pass
	
func player_movement(delta):
	inputAxis = get_input()
	
	if inputAxis == Vector2.ZERO:
		if velocity.length() > (friction * delta): #check if char still moving
			velocity -= velocity.normalized() * (friction * delta) #if char still got velocity, decrease it
		else: 
			velocity = Vector2.ZERO
	else: #increase the velocity until the max limit
		velocity += (inputAxis * accel * delta) #acceleration
		velocity = velocity.limit_length(maxSpeed) #limiter
		
	move_and_slide()#moves in accordance to built-in velocity values
	pass

func mc_animate():
	if Input.is_action_pressed("atk1"):
		_anim.play("soldier_atk1")
	elif Input.is_action_pressed("atk2"):
		_anim.play("soldier_atk2")
	elif Input.is_action_pressed("atk3"):
		_anim.play("soldier_atk3")
	else:
		if Input.is_action_pressed("toLeft"):
			if $AnimatedSprite2D.flip_h == false:
				$AnimatedSprite2D.flip_h = true
			_anim.play("soldier_walk")
			pass
		elif Input.is_action_pressed("toRight"):
			if $AnimatedSprite2D.flip_h == true:
				$AnimatedSprite2D.flip_h = false
			_anim.play("soldier_walk")
			pass
		elif attack_ip == false || Input.is_action_just_released("toLeft") || Input.is_action_just_released("toRight"):
			_anim.play("soldier_idle")
		pass
	pass

func player():
	pass

func _on_player_hitbox_body_entered(body, area):
	if body.has_method("enemy"):
		enemy_in_atk_range = true
		
	if area.has_method("collect"):
		area.collect()


func _on_player_hitbox_body_exited(body):
	if body.has_method("enemy"):
		enemy_in_atk_range = false

func enemy_attack():
	if enemy_in_atk_range and enemy_attack_cooldown ==true:
		health = health - 5
		enemy_attack_cooldown = false
		$attack_cooldown.start()
		print("player health = ", health)


func _on_attack_cooldown_timeout():
	enemy_attack_cooldown = true

func attack():
	#var dir = current_dir
	if Input.is_action_just_pressed("atk1"):
		Global.player_current_attack = true
		attack_ip = true
		if $AnimatedSprite2D.flip_h == false:
			$AnimatedSprite2D.play("soldier_atk1")
			$deal_attack_timer.start()
		if $AnimatedSprite2D.flip_h == true:
			$AnimatedSprite2D.play("soldier_atk1")
			$deal_attack_timer.start()


func _on_deal_attack_timer_timeout():
	$deal_attack_timer.stop()
	Global.player_current_attack = false
	attack_ip = false

func _on_hurt_box_area_entered(area):
	if area.has_method("collecting"):
		area.collecting()
