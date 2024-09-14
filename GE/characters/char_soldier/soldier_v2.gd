extends CharacterBody2D

class_name player

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
var max_health = Global.health
var health = max_health

var player_alive = true
var attack_ip = false

@onready var _anim = $AnimatedSprite2D
@onready var actionable_finder = $Direction/ActionableFinder
@onready var body_interactor = $player_hitbox

@export var soldier_atk1dmg = Global.dmg
@export var soldier_atk2dmg = Global.dmg + 5

var damage = 0
var slime
var damage_deal
var atk2_cooldown = false

@export var inventory: Inventory

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
	#print("Signals connected")
	_anim.play("soldier_idle")
	slime = get_node("../slimev3")
	pass
	
func _physics_process(delta):
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
	
	if (Global.GoddessHeal == true):
		health = 100
		Global.GoddessHeal = false
		
	pass
	
func check_interact():
	if Input.is_action_just_pressed("Interact"):
		var actionables = actionable_finder.get_overlapping_areas()
		print(actionables)
		if actionables.size() > 1: #always more than one since overlap with hitbox
			print(actionables)
			var actionable = actionables[1]
			if (actionable.has_method("action")):
				actionable.action()
	
	if Input.is_action_just_pressed("createTile"):
		place_tile_in_front()
	
	if Input.is_action_just_pressed("createWoodenBlock"):
		place_wooden_blocks()
		
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
	if (Global.disablePlayerInput == false):
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
			current_dir = "down"
			play_anim(1)
			velocity.y = maxSpeed
			velocity.x = 0
		elif Input.is_action_pressed("toUp"):
			current_dir = "up"
			play_anim(1)
			velocity.y = -maxSpeed
			velocity.x = 0
		else:
			play_anim(0)
			velocity.x = 0
			velocity.y = 0
		
		move_and_slide()

#func player_movement(delta):
	#if Global.disablePlayerInput == false:
		#if Input.is_action_pressed("toRight"):
			#current_dir = "right"
			#play_anim(1)
			#velocity.x = min(velocity.x + accel * delta, maxSpeed)
			#velocity.y = 0  
		#elif Input.is_action_pressed("toLeft"):
			#current_dir = "left"
			#play_anim(1)
			#velocity.x = max(velocity.x - accel * delta, -maxSpeed)  
			#velocity.y = 0
		#elif Input.is_action_pressed("toDown"):
			#current_dir = "down"
			#play_anim(1)
			#velocity.y = min(velocity.y + accel * delta, maxSpeed)  
			#velocity.x = 0  
		#elif Input.is_action_pressed("toUp"):
			#current_dir = "up"
			#play_anim(1)
			#velocity.y = max(velocity.y - accel * delta, -maxSpeed)  
			#velocity.x = 0
		#
		#else:
			#play_anim(0)
			#velocity.x = move_toward(velocity.x, 0, friction * delta)
			#velocity.y = move_toward(velocity.y, 0, friction * delta)
			
		#move_and_slide()

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
				
	if dir == "down":
		#anim.flip_h = true
		if movement == 1:
			anim.play("soldier_walk")
		elif movement == 0:
			if attack_ip == false:
				anim.play("soldier_idle")
				
	if dir == "up":
		#anim.flip_h = true
		if movement == 1:
			anim.play("soldier_walk")
		elif movement == 0:
			if attack_ip == false:
				anim.play("soldier_idle")

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
	if enemy_in_atk_range and enemy_attack_cooldown == true:
		
		# fetch the damage from the slime
		#damage_deal = slime.slime_atk1dmg
		#health = health - damage_deal
		enemy_attack_cooldown = false
		$attack_cooldown.start()
		print("player health = ", health)

func update_health():
	var healthbar = $healthbar
	healthbar.value = health

func _on_regen_timer_timeout():
	if health < max_health:
		health = health + 2
		if health > max_health:
			health = max_health
	if health <= 0:
		health = 0

func increase_health(amount: int) -> void:
	health += amount
	health = min(max_health, health)
		
	#healthChanged.emit(health)
		
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
		elif dir == "left":
			$AnimatedSprite2D.flip_h = true
			$AnimatedSprite2D.play("soldier_atk1")
			$deal_attack_timer.start()
		elif dir == "down" || dir == "up":
			$AnimatedSprite2D.play("soldier_atk1")
			$deal_attack_timer.start()

	
	if Input.is_action_just_pressed("atk2") and not atk2_cooldown:
		Global.player_current_attack = true
		attack_ip = true
		damage = soldier_atk2dmg
		print("Attack 2 Damage: ", damage)
		if dir == "right":
			$AnimatedSprite2D.flip_h = false
			$AnimatedSprite2D.play("soldier_atk2")
			$deal_attack_timer.start()
		elif dir == "left":
			$AnimatedSprite2D.flip_h = true
			$AnimatedSprite2D.play("soldier_atk2")
			$deal_attack_timer.start()
		elif dir == "down" || dir == "up":
			$AnimatedSprite2D.play("soldier_atk2")
			$deal_attack_timer.start()
		atk2_cooldown = true
		$atk2_cooldown.start()


func _on_deal_attack_timer_timeout():
	$deal_attack_timer.stop()
	Global.player_current_attack = false
	attack_ip = false
	#_anim.play("soldier_idle")
	
func _on_key_picked_up():
	check_key_count()  # Call the function here when a key is picked up

func check_key_count():
	var key_count = inventory.get_total_keys()
	if key_count == 3:
		print("You have exactly 3 keys!")
	else:
		print("You have", key_count, "keys.")

# For using Health_Item
func _on_player_hitbox_area_entered(area):
	if area.has_method("collect"):
		print("Collected the Item", area)
		area.collect(inventory)
		check_key_count()
	else:
		print("No collect meth found for:", area)

# func for placing tiles
func place_tile_in_front():
	# Get the player's facing direction (assuming you have a velocity-based movement)
	var facing_direction = current_dir
	var position_in_front
	
	# Calculate the world position in front of the player
	if (current_dir == "right"):
		position_in_front = self.global_position + Vector2(16, 0)
	elif (current_dir == "left"):
		position_in_front = self.global_position + Vector2(-16, 0)
	elif (current_dir == "down"):
		position_in_front = self.global_position + Vector2(0, 16)
	elif (current_dir == "up"):
		position_in_front = self.global_position + Vector2(0, -16)
	
	var tilemap = Global.currentTilemap
	var source_id
	# Convert world position to tilemap coordinates

	var tile_position = Global.currentTilemap.local_to_map(position_in_front)
	if (tilemap.name == "IslandTileMap"):
		source_id = 7
	elif (tilemap.name == "PlainTileMap"):
		source_id = 0
	elif (tilemap.name == "BeachTileMap"):
		source_id = 3
	elif (tilemap.name == "WinterfellTileMap"):
		source_id = 0
	elif (tilemap.name == "VolcanoTileMap"):
		source_id = 4
	
	# Place the tile in front of the player
	tilemap.set_cell(4, tile_position, source_id, Vector2(0, 0))
	print("Tile placed at: ", tile_position)
	
	# Reduce the number of BuildingItems in the inventory after placing a block
	var item_slots = inventory.slots.filter(func(slot): return slot.item is BuildingItem and slot.amount > 0)
	if !item_slots.is_empty():
		item_slots[0].amount -= 1
		if item_slots[0].amount == 0:
			inventory.removeSlot(item_slots[0])

	inventory.updated.emit()  # Emit the updated signal after placing a block


func _on_atk_2_cooldown_timeout():
	atk2_cooldown = false

func place_wooden_blocks():
	var facing_direction = current_dir
	var position_in_front
	
	# Calculate the world position in front of the player
	if (current_dir == "right"):
		position_in_front = self.global_position + Vector2(16, 0)
	elif (current_dir == "left"):
		position_in_front = self.global_position + Vector2(-16, 0)
	elif (current_dir == "down"):
		position_in_front = self.global_position + Vector2(0, 16)
	elif (current_dir == "up"):
		position_in_front = self.global_position + Vector2(0, -16)
	
	var tilemap = Global.currentTilemap
	var source_id
	# Convert world position to tilemap coordinates

	var tile_position = Global.currentTilemap.local_to_map(position_in_front)
	
	if (tilemap.name == "IslandTileMap"):
		source_id = 7
	elif (tilemap.name == "PlainTileMap"):
		source_id = 0
	elif (tilemap.name == "BeachTileMap"):
		source_id = 3
		
	var sourceId = 0
	var base_atlas_coord = Vector2(8, 10)
	
	 # Coordinates for each of the 2x2 tiles (relative to the base position)
	var tile_offsets = [
		Vector2i(-1, 1),  # Top-left
		Vector2i(0, 1),  # Top-right
		Vector2i(-1, 2),  # Bottom-left
		Vector2i(0, 2)   # Bottom-right
		#all y axis are + 1 to create at the feet so can directly walk thru
	]
	
	var atlas_offsets = [
		Vector2(0, 0),  # Top-left
		Vector2(1, 0),  # Top-right
		Vector2(0, 1),  # Bottom-left
		Vector2(1, 1)   # Bottom-right
	]
	
	print(tile_position)
	for i in range (4):
		var currentTilePosition = tile_position + tile_offsets[i]
		var currentAtlasCoord = base_atlas_coord + atlas_offsets[i]
		var deleteCollisionPosition = currentTilePosition + Vector2i(0, -1) #let the player walk pass
		Global.removeCollision((deleteCollisionPosition))
		tilemap.set_cell(4, currentTilePosition, sourceId, currentAtlasCoord)

func take_damage(amount: int) -> void:
	health -= amount
	print("Player took damage! Current health:", health)
	if health <= 0:
		die()

func die():
	# Handle player death
	queue_free()  # Or any other death logic
