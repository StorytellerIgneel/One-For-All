extends CharacterBody2D

var current_states = enemy_status.MOVERIGHT
enum enemy_status {MOVERIGHT, MOVELEFT, MOVEUP, MOVEDOWN, STOP, DEAD, ATTACK}
var player = null
var player_chase = false
var fspeed = 1.0
var player_in_attack_zone = false
var can_take_damage = true

@export var orc_atk1dmg = 10
@export var speed = 30
@export var health = 100
var dir
var custom_velocity = Vector2.ZERO  # Renamed variable to avoid conflict with CharacterBody2D's velocity

var attack_counter = 0  # Track the number of consecutive attacks
var skill_threshold = 5  # Number of attacks before skill is triggered

@onready var hitbox_area = $hitbox_area  # Ensure hitbox_area is correctly initialized
@onready var attack_cooldown_timer = $attack_cooldown  # Ensure attack_cooldown Timer is correctly initialized
@onready var skill_cooldown_timer = $skill_cooldown

func _ready():
	# Ensure death_time Timer is not running automatically
	$death_time.autostart = false
	# Set up move_change Timer
	$move_change.wait_time = 1.0
	$move_change.one_shot = false
	$move_change.start()
	attack_cooldown_timer.wait_time = 1.5  # Cooldown duration
	attack_cooldown_timer.one_shot = true  # Ensure it only fires once per activation
	

func _physics_process(delta):
	deal_with_damage()
	updateHealth()
	if health <= 0:
		if current_states != enemy_status.DEAD:
			current_states = enemy_status.DEAD
			dead()
	elif player_chase:
		if current_states != enemy_status.ATTACK:
			if player.position:
				# Calculate movement towards the player
				custom_velocity = (player.position - position).normalized() * speed
				# Move the character towards the player
				velocity = custom_velocity
				move_and_slide()  # Use move_and_slide() without arguments
				$orc.play("walk")
				$orc.flip_h = (player.position.x - position.x) < 0

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
	if $orc.animation == "death" and !$orc.is_playing():
		queue_free()

func dead():
	custom_velocity = Vector2.ZERO
	$orc.play('death')
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
	$orc.play('walk')
	$orc.flip_h = false

func move_left():
	custom_velocity = Vector2(-speed, 0)
	$orc.play('walk')
	$orc.flip_h = true

func move_up():
	custom_velocity = Vector2(0, -speed)
	$orc.play('walk')

func move_down():
	custom_velocity = Vector2(0, speed)
	$orc.play('walk')

func stop():
	custom_velocity = Vector2.ZERO
	$orc.play('idle')


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
		$orc.play('hurt')
		if can_take_damage:
			health -= 20
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
		custom_velocity = Vector2.ZERO
		print("this line is done")
		attack_counter += 1  # Increment attack counter

		if attack_counter >= skill_threshold:
			$orc.play("skill")  # Play the "skill" animation
			attack_counter = 0  # Reset attack counter after skill is triggered
		else:
			$orc.play("attack")  # Regular attack animation
			

		if player and player.has_method("take_damage"):
			player.take_damage(orc_atk1dmg)

func updateHealth():
	var healthbar = $hpBar
	
	healthbar.value = health
	
	if health >= 100:
		healthbar.visible = false
	else:
		healthbar.visible = true

func enemy():
	pass


func _on_skill_cooldown_timeout():
	pass # Replace with function body.

func deduct_hp(damage: int):
	health -= damage
	
