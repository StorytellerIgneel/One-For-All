extends CharacterBody2D
 
var current_states = enemy_status.MOVERIGHT
enum enemy_status {MOVERIGHT, MOVELEFT, MOVEUP, MOVEDOWN, STOP, DEAD, ATTACK}
var player = null
var player_chase = false
var fspeed = 1.5
var player_in_attack_zone = false
var can_take_damage = true
 
@export var slime_atk1dmg = 5
@export var speed = 30
@export var health = 100
var dir
var move_direction = Vector2.ZERO  # This will hold the movement direction
 
@onready var hitbox_area = $hitbox_area  # Ensure hitbox_area is correctly initialized
@onready var attack_cooldown_timer = $attack_cooldown  # Ensure attack_cooldown Timer is correctly initialized
 
func _ready():
	$death_time.autostart = false
	$move_change.wait_time = 3.0
	$move_change.one_shot = false
	$move_change.start()
	attack_cooldown_timer.wait_time = 1.0  # Cooldown duration
	attack_cooldown_timer.one_shot = true  # Ensure it only fires once per activation
 
func _physics_process(delta):
	deal_with_damage()
	updateHealth()
 
	if health <= 0:
		if current_states != enemy_status.DEAD:
			current_states = enemy_status.DEAD
			dead()
	elif player_chase and player:
		if current_states != enemy_status.ATTACK:
			if player.position:
				var distance_to_player = player.position.distance_to(position)
 
				# Only chase if player is far enough away
				if distance_to_player > 10:  # Adjust this threshold based on your needs
					# Move towards the player manually
					move_direction = (player.position - position).normalized() * speed * delta
					position += move_direction  # Update the position directly
				else:
					move_direction = Vector2.ZERO  # Stop moving if too close
 
				$slime.play("walk")
				$slime.flip_h = (player.position.x - position.x) < 0
 
			# Stop the move_change timer while chasing
			if !$move_change.is_stopped():
				$move_change.stop()
 
			# Attack logic when in attack range
			if attack_cooldown_timer.is_stopped() and hitbox_area and hitbox_area.overlaps_body(player):
				current_states = enemy_status.ATTACK
				attack()
				attack_cooldown_timer.start()
		else:
			# Stop moving while attacking
			move_direction = Vector2.ZERO
	else:
		# Handle random movement when not chasing the player
		if $move_change.is_stopped():
			$move_change.start()
 
		if $move_change.wait_time == 0:
			_on_move_change_timeout()
			$move_change.start()
 
		match current_states:
			enemy_status.MOVERIGHT:
				move_right(delta)
			enemy_status.MOVELEFT:
				move_left(delta)
			enemy_status.MOVEUP:
				move_up(delta)
			enemy_status.MOVEDOWN:
				move_down(delta)
			enemy_status.STOP:
				stop()
 
	# Check if animation has ended and queue_free() if necessary
	if $slime.animation == "death" and !$slime.is_playing():
		queue_free()
 
func dead():
	move_direction = Vector2.ZERO
	$slime.play('death')
	$death_time.start()
 
# Called when the move_change timer times out
func _on_move_change_timeout():
	random_generation()
 
# Random movement generation
func random_generation():
	dir = randi() % 5
	random_direction()
 
func random_direction():
	match dir:
		0:
			current_states = enemy_status.MOVERIGHT
		1:
			current_states = enemy_status.MOVELEFT
		2:
			current_states = enemy_status.MOVEUP
		3:
			current_states = enemy_status.MOVEDOWN
		4:
			current_states = enemy_status.STOP
 
func move_right(delta):
	move_direction = Vector2(speed * delta, 0)
	position += move_direction
	$slime.play('walk')
	$slime.flip_h = false
 
func move_left(delta):
	move_direction = Vector2(-speed * delta, 0)
	position += move_direction
	$slime.play('walk')
	$slime.flip_h = true
 
func move_up(delta):
	move_direction = Vector2(0, -speed * delta)
	position += move_direction
	$slime.play('walk')
 
func move_down(delta):
	move_direction = Vector2(0, speed * delta)
	position += move_direction
	$slime.play('walk')
 
func stop():
	move_direction = Vector2.ZERO
	$slime.play('idle')
 
func _on_area_detection_body_entered(body):
	if body.has_method("player"):
		player = body as CharacterBody2D
		player_chase = true
		if !$move_change.is_stopped():
			$move_change.stop()
 
func _on_area_detection_body_exited(body):
	if body.has_method("player"):
		player_chase = false
		if $move_change.is_stopped():
			$move_change.start()
		random_generation()
 
func _on_hitbox_area_body_entered(body):
	if body.has_method("player"):
		player_in_attack_zone = true
 
func _on_hitbox_area_body_exited(body):
	if body.has_method("player"):
		player_in_attack_zone = false
 
func deal_with_damage():
	if player_in_attack_zone and Global.player_current_attack == true:
		$slime.play('hurt')
		if can_take_damage:
			health -= 20
			$take_damage_cooldown.start()
			can_take_damage = false
			print("Slime health:", health)
			if health <= 0:
				dead()
 
func _on_take_damage_cooldown_timeout():
	can_take_damage = true
 
func _on_death_time_timeout():
	queue_free()
 
func _on_attack_cooldown_timeout():
	current_states = enemy_status.MOVERIGHT
 
func attack():
	if hitbox_area and hitbox_area.overlaps_body(player):
		move_direction = Vector2.ZERO  # Stop movement during the attack
		$slime.play("attack")
		if player and player.has_method("take_damage"):
			player.take_damage(slime_atk1dmg)
 
func updateHealth():
	var healthbar = $hpBar
	healthbar.value = health
	if health >= 100:
		healthbar.visible = false
	else:
		healthbar.visible = true
