extends CharacterBody2D

class_name Knight_Templar

var enemy_in_atk_range = false
var enemy_attack_cooldown = true

var max_health = Global.health
var health = max_health

var player_alive = true
var attack_ip = false

@onready var _anim = $AnimatedSprite2D
@onready var actionable_finder = $Direction/ActionableFinder
@onready var body_interactor = $player_hitbox

@export var knighttemp_atk1dmg = Global.dmg + 10
@export var knighttemp_atk2dmg = Global.dmg + 15
@export var knighttemp_atk3dmg = Global.dmg + 20

@export var inventory: Inventory

var damage = 0
var slime
var damage_deal
var atk2_cooldown = false
var atk3_cooldown = false

# No Problem
func _on_key_picked_up():
	check_key_count()  # Call the function here when a key is picked up

# No Problem
func check_key_count():
	var key_count = inventory.get_total_keys()
	if key_count == 3:
		print("You have exactly 3 keys!")
	else:
		print("You have", key_count, "keys.")

var maxSpeed: int = 100
var accel:int = 10000
var friction:int = 1000
var current_dir = "none"

# Called when the node enters the scene tree for the first time.
func _ready():
	_anim.play("knight.t_idle")
	slime = get_node("../slimev3")

func use_item(item: InventoryItem) -> void:
	item.use(self)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	if(Global.disablePlayerInput == false):
		player_movement(delta)
		check_interact()
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

func play_anim(movement):
	var dir = current_dir
	
	if dir == "right":
		_anim.flip_h = false
		if movement == 1:
			_anim.play("knight.t_walk")
		elif movement == 0:
			if attack_ip == false:
				_anim.play("knight.t_idle")
	
	if dir == "left":
		_anim.flip_h = true
		if movement == 1:
			_anim.play("knight.t_walk")
		elif movement == 0:
			if attack_ip == false:
				_anim.play("knight.t_idle")

func player():
	pass

func _on_player_hitbox_body_entered(body):
	if body.has_method("enemy"):
		enemy_in_atk_range = true


func _on_player_hitbox_body_exited(body):
	if body.has_method("enemy"):
		enemy_in_atk_range = false

func enemy_attack():
	if enemy_in_atk_range and enemy_attack_cooldown ==true:
		
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

func _on_attack_cooldown_timeout():
	enemy_attack_cooldown = true

func attack():
	var dir = current_dir
	
	if Input.is_action_just_pressed("atk1"):
		Global.player_current_attack = true
		attack_ip = true
		damage = knighttemp_atk1dmg
		print("Attack 1 Damage: ", damage)  # Debugging: check damage value
		if dir == "right":
			$AnimatedSprite2D.flip_h = false
			$AnimatedSprite2D.play("knight.t_atk1")
			$deal_attack_timer.start()
		elif dir == "left":
			$AnimatedSprite2D.flip_h = true
			$AnimatedSprite2D.play("knight.t_atk1")
			$deal_attack_timer.start()
	
	if Input.is_action_just_pressed("atk2"):
		Global.player_current_attack = true
		attack_ip = true
		damage = knighttemp_atk1dmg
		print("Attack 2 Damage: ", damage)  # Debugging: check damage value
		if dir == "right":
			$AnimatedSprite2D.flip_h = false
			$AnimatedSprite2D.play("knight.t_atk2")
			$deal_attack_timer.start()
		elif dir == "left":
			$AnimatedSprite2D.flip_h = true
			$AnimatedSprite2D.play("knight.t_atk2")
			$deal_attack_timer.start()
		atk2_cooldown = true
		$atk2_cooldown.start()

	if Input.is_action_just_pressed("atk3"):
		Global.player_current_attack = true
		attack_ip = true
		damage = knighttemp_atk1dmg
		print("Attack 3 Damage: ", damage)  # Debugging: check damage value
		if dir == "right":
			$AnimatedSprite2D.flip_h = false
			$AnimatedSprite2D.play("knight.t_atk3")
			$deal_attack_timer.start()
		elif dir == "left":
			$AnimatedSprite2D.flip_h = true
			$AnimatedSprite2D.play("knight.t_atk3")
			$deal_attack_timer.start()
			
		atk3_cooldown = true
		$atk3_cooldown.start()

func _on_deal_attack_timer_timeout():
	$deal_attack_timer.stop()
	Global.player_current_attack = false
	attack_ip = false

# No problem
func _on_player_hitbox_area_entered(area):
	if area.has_method("collect"):
		print("Collected the Item", area)
		area.collect(inventory)
	else:
		print("No collect meth found for:", area)

func _on_atk_2_cooldown_timeout():
	atk2_cooldown = false

func _on_atk_3_cooldown_timeout():
	atk3_cooldown = false



