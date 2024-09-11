extends CharacterBody2D

var speed = 50
var player_chase = false
var player = null

var health = 100
@export var slime_atk1dmg = 5
var player_in_attack_zone = false
var can_take_damage = true
var damage = 0
var soldier
var damage_deal

func _ready():
	soldier = get_node("../soldierV2")

func _physics_process(delta):
	deal_with_damage()
	update_health()
	
	if player_chase:
		position += (player.position - position)/speed

func _on_area_2d_body_entered(body):
	player = body
	player_chase = true


func _on_area_2d_body_exited(body):
	player = null
	player_chase = false

func enemy():
	pass


func _on_enemy_hitbox_body_entered(body):
	if body.has_method("player"):
		player_in_attack_zone = true


func _on_enemy_hitbox_body_exited(body):
	if body.has_method("player"):
		player_in_attack_zone = false

func deal_with_damage():
	if player_in_attack_zone and Global.player_current_attack == true:
		if can_take_damage == true:
			
			# fetch the damage from the soldier
			damage_deal = soldier.damage
			print("The damage received: ", damage_deal)
			health = health - damage_deal
			$take_damage_cooldown.start()
			can_take_damage = false
			print("slime health = ", health)
		
			if health <= 0:
				self.queue_free()


func _on_take_damage_cooldown_timeout():
	can_take_damage = true
	

func update_health():
	var healthbar = $healthbar
	healthbar.value = health
