extends CharacterBody2D

var speed = 50
var direction = Vector2.LEFT # initial direction to left
var left_limit = -25
var right_limit = 25
var idle_time = 2 # time to idle on each side

var is_idle = false # to see if the NPC is idling

var starting_position = Vector2()

@onready var anim = $AnimatedSprite2D
@onready var idle_timer = $idle_timer

func _ready():
	# store the npc starting position
	starting_position = position
	
	# connect the idle timer timeout signal
	#idle_timer.connect("timeout", Callable(self, "_on_idle_timeout"))
	idle_timer.timeout.connect(self._on_idle_timeout)
	
	# start moving
	_move(direction)

func _physics_process(delta):
	if not is_idle:
		# apply movement based on the direction and speed
		velocity.x = direction.x * speed
		move_and_slide()
	
		# check if NPC has reached the left or right limit
		if position.x <= starting_position.x + left_limit:
			_start_idle(Vector2.RIGHT)
		elif position.x >= starting_position.x + right_limit:
			_start_idle(Vector2.LEFT)

# this func starts idling, facing new direction after moving
func _start_idle(new_direction):
	is_idle = true
	velocity.x = 0
	move_and_slide()
	
	# set new direction
	direction = new_direction
	
	# play animation
	#if direction == Vector2.RIGHT:
		#anim.flip_h = false
	#else:
		#anim.flip_h = true
		
	anim.play("priest_idle")
		
	# start the idle timer
	idle_timer.start(idle_time)
	
func _on_idle_timeout():
	is_idle = false
	
	_move(direction)

func _move(new_direction):
	direction = new_direction
	
	if direction == Vector2.RIGHT:
		anim.flip_h = false
	else:
		anim.flip_h = true
		
	anim.play("priest_walk")
