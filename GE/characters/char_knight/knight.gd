extends CharacterBody2D

signal healthChanged

var enemy_in_atk_range = false
var enemy_attack_cooldown = true

var max_health = 100
var health = max_health

#var health = 100
var player_alive = true
var attack_ip = false

@onready var _anim = $AnimatedSprite2D
@onready var actionable_finder = $Direction/ActionableFinder
@onready var body_interactor = $player_hitbox

@export var knight_atk1dmg = 10
@export var knight_atk2dmg = 15
@export var knight_atk3dmg = 20
var damage = 0
#var slime
var damage_deal

@export var inventory: Inventory


var maxSpeed: int = 100
var accel:int = 10000
var friction:int = 1000
var current_dir = "none"

func get_hitbox():
	return $player_hitbox
	
func _ready():

	$player_hitbox.connect("area_entered", Callable(self, "_on_player_hitbox_body_entered"))
	inventory.use_item.connect(use_item)
	print("Signals connected")
	_anim.play("knight_idle")

	pass

func _physics_process(delta):
	print("test")
	if(State.is_dialogue_active == false):
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
			State.is_dialogue_active = true
			var actionable = actionables[0]
			actionable.action()
	State.is_dialogue_active = false
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
	
	if dir == "right":
		_anim.flip_h = false
		if movement == 1:
			_anim.play("soldier_walk")
		elif movement == 0:
			if attack_ip == false:
				_anim.play("soldier_idle")
	
	if dir == "left":
		_anim.flip_h = true
		if movement == 1:
			_anim.play("soldier_walk")
		elif movement == 0:
			if attack_ip == false:
				_anim.play("soldier_idle")
				
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
	
func enemy_attack():
	if enemy_in_atk_range and enemy_attack_cooldown ==true:
		
		# fetch the damage from the slime
		#damage_deal = slime.slime_atk1dmg
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
	print("test")
	var dir = current_dir
	
	if Input.is_action_just_pressed("atk1"):
		print("test")
		Global.player_current_attack = true
		attack_ip = true
		damage = knight_atk1dmg
		print("Attack 1 Damage: ", damage)  # Debugging: check damage value
		if dir == "right":
			$AnimatedSprite2D.flip_h = false
			$AnimatedSprite2D.play("knight_atk1")
			$deal_attack_timer.start()
		if dir == "left":
			$AnimatedSprite2D.flip_h = true
			$AnimatedSprite2D.play("knight_atk1")
			$deal_attack_timer.start()
		if dir == "down" || dir == "up":
			$AnimatedSprite2D.play("knight_atk1")
			$deal_attack_timer.start()
	
	if Input.is_action_just_pressed("atk2"):
		Global.player_current_attack = true
		attack_ip = true
		damage = knight_atk2dmg
		if dir == "right":
			$AnimatedSprite2D.flip_h = false
			$AnimatedSprite2D.play("knight_atk2")
			$deal_attack_timer.start()
		if dir == "left":
			$AnimatedSprite2D.flip_h = true
			$AnimatedSprite2D.play("knight_atk2")
			$deal_attack_timer.start()
		if dir == "down" || dir == "up":
			$AnimatedSprite2D.play("knight_atk2")
			$deal_attack_timer.start()
	
	if Input.is_action_just_pressed("atk3"):
		Global.player_current_attack = true
		attack_ip = true
		damage = knight_atk2dmg
		if dir == "right":
			$AnimatedSprite2D.flip_h = false
			$AnimatedSprite2D.play("knight_atk2")
			$deal_attack_timer.start()
		if dir == "left":
			$AnimatedSprite2D.flip_h = true
			$AnimatedSprite2D.play("knight_atk2")
			$deal_attack_timer.start()
		if dir == "down" || dir == "up":
			$AnimatedSprite2D.play("knight_atk2")
			$deal_attack_timer.start()

func _on_deal_attack_timer_timeout():
	$deal_attack_timer.stop()
	Global.player_current_attack = false
	attack_ip = false
	#_anim.play("soldier_idle")

func _on_area_2d_area_entered(area):
	if area.has_method("collect"):
		print("Collected the Item", area)
		area.collect(inventory)
	else:
		print("No collect meth found for:", area)


func _on_area_2d_body_entered(body):
	if body.has_method("enemy"):
		enemy_in_atk_range = true


func _on_area_2d_body_exited(body):
	if body.has_method("enemy"):
		enemy_in_atk_range = false
