
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
var custom_velocity = Vector2.ZERO  # Renamed variable to avoid conflict with CharacterBody2D's velocity
var soldier

@onready var hitbox_area = $hitbox_area  # Ensure hitbox_area is correctly initialized
@onready var attack_cooldown_timer = $attack_cooldown  # Ensure attack_cooldown Timer is correctly initialized

func _ready():
	# Ensure death_time Timer is not running automatically
	soldier = get_node("../soldierV2")
	$death_time.autostart = false
	# Set up move_change Timer
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
			var distance_to_player = (player.position - position).length()
			if distance_to_player > 10:
				custom_velocity = (player.position - position).normalized() * speed
			else:
				custom_velocity = Vector2.ZERO
			
			velocity = custom_velocity
			move_and_slide()
			$slime.play("walk")
			$slime.flip_h = (player.position.x - position.x) < 0
			

			# Stop the move_change timer while chasing
			if !$move_change.is_stopped():
				$move_change.stop()

			if attack_cooldown_timer.is_stopped() and hitbox_area and hitbox_area.overlaps_body(player):
				# Change state to ATTACK
				current_states = enemy_status.ATTACK
				attack()
				attack_cooldown_timer.start()  # Restart the cooldown timer
		else:
			# If in ATTACK state, do not move
			velocity = Vector2.ZERO
			move_and_slide()
	else:
		# Handle random movement if not chasing the player
		if $move_change.is_stopped():
			$move_change.start()  # Start the timer if stopped

		# Check if the move_change Timer has timed out
		if $move_change.wait_time == 0:
			_on_move_change_timeout()  # Manually call the timeout handler
			$move_change.start()  # Restart the timer after handling the timeout

		match current_states:
			enemy_status.MOVERIGHT:
				move_right()
			enemy_status.MOVELEFT:
				move_left()
			enemy_status.MOVEUP:
				move_up()
			enemy_status.MOVEDOWN:
				move_down()
			enemy_status.STOP:
				stop()

		# Apply custom velocity for movement
		velocity = custom_velocity
		move_and_slide()  # Use move_and_slide() without arguments

	# Check if animation has ended and queue_free() if necessary
	if $slime.animation == "death" and !$slime.is_playing():
		queue_free()

func dead():
	custom_velocity = Vector2.ZERO
	$slime.play('death')
	$death_time.start()  # Start Timer when death animation plays

# This function will be called when the move_change timer times out
func _on_move_change_timeout():
	#print("Timer triggered: Changing direction randomly")
	random_generation()

# Random movement generation
func random_generation():
	dir = randi() % 5
	#print("Generated direction:", dir)
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

func move_right():
	custom_velocity = Vector2(speed, 0)
	$slime.play('walk')
	$slime.flip_h = false

func move_left():
	custom_velocity = Vector2(-speed, 0)
	$slime.play('walk')
	$slime.flip_h = true

func move_up():
	custom_velocity = Vector2(0, -speed)
	$slime.play('walk')

func move_down():
	custom_velocity = Vector2(0, speed)
	$slime.play('walk')

func stop():
	custom_velocity = Vector2.ZERO
	$slime.play('idle')


# Handle area detections for player chase
func _on_area_detection_body_entered(body):
	if body.has_method("player"):
		player = body as CharacterBody2D  # Ensure correct type casting
		player_chase = true
		if !$move_change.is_stopped():
			$move_change.stop()  # Stop the move_change timer when player is detected

func _on_area_detection_body_exited(body):
	if body.has_method("player"):
		player_chase = false
		if $move_change.is_stopped():
			$move_change.start()  # Resume direction change when not chasing
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
		var damage = soldier.damage
		if can_take_damage:
			health -= damage
			$take_damage_cooldown.start()
			can_take_damage = false
			print("Slime health:", health)
			if health <= 0:
				dead()

func _on_take_damage_cooldown_timeout():
	can_take_damage=true

func _on_death_time_timeout():
	queue_free()

func _on_attack_cooldown_timeout():
	#print("Attack cooldown finished. Ready to attack again.")
	current_states = enemy_status.MOVERIGHT  # Resume movement after attack

func attack():
	if hitbox_area and hitbox_area.overlaps_body(player):
		custom_velocity = Vector2.ZERO  # Stop movement during the attack
		#print("Attacking player!")
		$slime.play("attack")  # Play attack animation
		Global.slime_current_attack = true
		# Apply damage or other effects to the player
		if player and player.has_method("take_damage"):
			player.take_damage(1)  # Assuming the player has a `take_damage` method

func updateHealth():
	var healthbar = $hpBar
	
	healthbar.value = health
	
	if health >= 100:
		healthbar.visible = false
	else:
		healthbar.visible = true

func enemy():
	pass


