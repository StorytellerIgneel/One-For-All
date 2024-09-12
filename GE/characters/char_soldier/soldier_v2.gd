
extends CharacterBody2D

class_name Player

signal InWaterRegion
signal OutWaterRegion
signal InFireRegion
signal OutFireRegion
signal healthChanged	

var enemy_in_atk_range = false
var enemy_attack_cooldown = true
var inWater_cooldown = false
var outWater_cooldown = false
var fire_cooldown = false
var max_health = 100
var health = max_health

#var health = 100
var player_alive = true
var attack_ip = false

@onready var _anim = $AnimatedSprite2D
@onready var actionable_finder = $Direction/ActionableFinder
@onready var body_interactor = $player_hitbox

@export var soldier_atk1dmg = 10
@export var soldier_atk2dmg = 15
@export var soldier_atk3dmg = 20
var damage = 0
var slime
var damage_deal

@export var inventory: Inventory

func check_key_count():
	var key_count = inventory.get_total_keys()
	if key_count == 3:
		print("You have exactly 3 keys!")
	else:
		print("You have", key_count, "keys.")


# Function to count total keys in the inventory
#func get_total_keys() -> int:
	#var key_count = 0
	#for item in inventory.items:
		#if item is Key:
			#key_count += item.key_amount  # Summing up all keys
	#return key_count
#
#func open_gate():
	#var total_keys = get_total_keys()
	#if total_keys == 3:
		#print("The gate opens with exactly 3 keys!")
		## Add your logic to open the gate
	#else:
		#print("You don't have exactly 3 keys.")

var bow_equipped = true
var bow_cooldown = true
var arrow = preload("res://characters/char_soldier/arrow.tscn")

var maxSpeed: int = 100
var accel:int = 10000
var friction:int = 1000
var current_dir = "none"

var inputAxis = Vector2.ZERO
var water_region: Area2D
var muddy_region: Area2D
var fire_region: Array[Area2D]

func set_water_region(region: Area2D):
	water_region = region

func set_muddy_region(region: Area2D):
	muddy_region = region

func set_fire_region(region: Array[Area2D]):
	fire_region = region

func get_hitbox():
	return $player_hitbox
	
func _ready():
	$inWaterTimer.connect("timeout", _on_inWaterTimer_timeout)
	$outWaterTimer.connect("timeout", _on_outWaterTimer_timeout)
	$fireTimer.connect("timeout", _on_fireTimer_timeout)
	$player_hitbox.connect("area_entered", Callable(self, "_on_player_hitbox_body_entered"))
	inventory.use_item.connect(use_item)
	print("Signals connected")
	_anim.play("soldier_idle")
	slime = get_node("../slimev3")
	pass

func _physics_process(delta):
	#print(Global.disablePlayerInput)
	if(Global.disablePlayerInput == false):
		player_movement(delta)
		check_interact()
	check_environment()
	enemy_attack()
	attack()
	update_health()
	
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
			var actionable = actionables[0]
			actionable.action()
	return

func check_environment():
	var actionables = body_interactor.get_overlapping_areas()
	if actionables.size() > 1:
		if (actionables[1] == water_region):
			if (inWater_cooldown == false):
				InWaterRegion.emit()
				inWater_cooldown = true
				$inWaterTimer.start()
		elif (actionables[1] == muddy_region):
			maxSpeed = 30
		elif (actionables[1] in fire_region):
			if (fire_cooldown == false):
				InFireRegion.emit()
				fire_cooldown = true
				$fireTimer.start()
			
	else: #section for cooling all level down
		if (outWater_cooldown == false):
			OutWaterRegion.emit()
			outWater_cooldown = true
			$outWaterTimer.start()
		OutFireRegion.emit()
		maxSpeed = 100
	return
	
	
func _on_inWaterTimer_timeout():
	inWater_cooldown = false

func _on_outWaterTimer_timeout():
	outWater_cooldown = false

func _on_fireTimer_timeout():
	fire_cooldown = false
	
	
func player_movement(delta):
	
	if Input.is_action_pressed("toRight"):
		current_dir = "right"
		play_anim(1)
		velocity.x = maxSpeed
		velocity.y = 0
	elif Input.is_action_pressed("toLeft"):
		current_dir = "left"
		play_anim(1)
		velocity.x = -maxSpeed
		velocity.y = 0
	elif Input.is_action_pressed("toDown"):
		#current_dir = "down"
		play_anim(1)
		velocity.y = maxSpeed
		velocity.x = 0
	elif Input.is_action_pressed("toUp"):
		#current_dir = "up"
		play_anim(1)
		velocity.y = -maxSpeed
		velocity.x = 0
	else:
		play_anim(0)
		velocity.x = 0
		velocity.y = 0
	
	move_and_slide()
	
func play_anim(movement):
	var dir = current_dir
	var anim = $AnimatedSprite2D
	
	if dir == "right":
		anim.flip_h = false
		if movement == 1:
			anim.play("soldier_walk")
		elif movement == 0:
			if attack_ip == false:
				anim.play("soldier_idle")
	
	if dir == "left":
		anim.flip_h = true
		if movement == 1:
			anim.play("soldier_walk")
		elif movement == 0:
			if attack_ip == false:
				anim.play("soldier_idle")
				
	#if dir == "down":
		##anim.flip_h = true
		#if movement == 1:
			#anim.play("soldier_walk")
		#elif movement == 0:
			#if attack_ip == false:
				#anim.play("soldier_idle")
				#
	#if dir == "up":
		##anim.flip_h = true
		#if movement == 1:
			#anim.play("soldier_walk")
		#elif movement == 0:
			#if attack_ip == false:
				#anim.play("soldier_idle")

func player():
	pass

func _on_player_hitbox_body_entered(body):
	if body.has_method("enemy"):
		enemy_in_atk_range = true
		
func _on_player_hitbox_body_exited(body):
	if body.has_method("enemy"):
		enemy_in_atk_range = false

# receive damage
func enemy_attack():
	if enemy_in_atk_range and Global.slime_current_attack and enemy_attack_cooldown == true:
		
		# fetch the damage from the slime
		damage_deal = slime.slime_atk1dmg
		health = health - damage_deal
		enemy_attack_cooldown = false
		$attack_cooldown.start()
		print("player health = ", health)

func update_health():
	var healthbar = $healthbar
	healthbar.value = health

func _on_regen_timer_timeout():
	if health < max_health:
		health = health + 0
		if health > max_health:
			health = max_health
	if health <= 0:
		health = 0

func increase_health(amount: int) -> void:
	health += amount
	health = min(max_health, health)
		
	healthChanged.emit(health)
		
	print("player health increase = ", health)
	
func use_item(item: InventoryItem) -> void:
	item.use(self)


func _on_attack_cooldown_timeout():
	enemy_attack_cooldown = true

func attack():
	var dir = current_dir
	
	if Input.is_action_just_pressed("atk1"):
		Global.player_current_attack = true
		attack_ip = true
		damage = soldier_atk1dmg
		print("Attack 1 Damage: ", damage)  # Debugging: check damage value
		if dir == "right":
			$AnimatedSprite2D.flip_h = false
			$AnimatedSprite2D.play("soldier_atk1")
			$deal_attack_timer.start()
		if dir == "left":
			$AnimatedSprite2D.flip_h = true
			$AnimatedSprite2D.play("soldier_atk1")
			$deal_attack_timer.start()
		if dir == "down" || dir == "up":
			$AnimatedSprite2D.play("soldier_atk1")
			$deal_attack_timer.start()
	
	if Input.is_action_just_pressed("atk2"):
		Global.player_current_attack = true
		attack_ip = true
		damage = soldier_atk2dmg
		print("Attack 2 Damage: ", damage)
		if dir == "right":
			$AnimatedSprite2D.flip_h = false
			$AnimatedSprite2D.play("soldier_atk2")
			$deal_attack_timer.start()
		if dir == "left":
			$AnimatedSprite2D.flip_h = true
			$AnimatedSprite2D.play("soldier_atk2")
			$deal_attack_timer.start()
		if dir == "down" || dir == "up":
			$AnimatedSprite2D.play("soldier_atk2")
			$deal_attack_timer.start()
	
	if Input.is_action_just_pressed("atk3") and bow_equipped and bow_cooldown:
		Global.player_current_attack = true
		attack_ip = true
		damage = soldier_atk3dmg
		bow_cooldown = false
		
		# Play attack animation
		$AnimatedSprite2D.play("soldier_atk3")
		
		# Wait for animation to finish
		await $AnimatedSprite2D.animation_finished
		
		# Create and configure arrow instance
		var arrow_instance = arrow.instantiate()
		arrow_instance.damage = soldier_atk3dmg # Pass damage to the arrow
		
		# Check which direction of soldier is facing and set arrow direction
		if _anim.flip_h == false:
			arrow_instance.rotation = 0
			arrow_instance.position = position + Vector2(10, 0) 
		else:
			arrow_instance.rotation = PI  # Facing left
			arrow_instance.position = position + Vector2(-10, 0)
		
		add_child(arrow_instance)
		
		# Cooldown for bow attack
		await get_tree().create_timer(1).timeout
		bow_cooldown = true
		$deal_attack_timer.start()

func _on_deal_attack_timer_timeout():
	$deal_attack_timer.stop()
	Global.player_current_attack = false
	attack_ip = false
	#_anim.play("soldier_idle")

func _on_player_hitbox_area_entered(area):
	if area.has_method("collect"):
		print("Collected the Item", area)
		area.collect(inventory)
	else:
		print("No collect meth found for:", area)


