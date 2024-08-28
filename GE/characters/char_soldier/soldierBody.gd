extends CharacterBody2D

@onready var _anim = $AnimatedSprite2D
@onready var actionable_finder = $Direction/ActionableFinder

const maxSpeed: int = 100
const accel:int = 10000
const friction:int = 1000

var isInteracting = false
var inputAxis = Vector2.ZERO

func _ready():
	_anim.play("soldier_idle")
	pass

func _physics_process(delta):
	mc_animate()
	check_interact()
	if (!isInteracting):
		player_movement(delta)
	pass

func check_interact():
	if Input.is_action_just_pressed("Interact"):
		var actionables = actionable_finder.get_overlapping_areas()
		if actionables.size() > 0:
			var actionable = actionables[0]
			isInteracting = true
			actionable.action()
	else:
		isInteracting = false
		return
	
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
	elif Input.is_action_just_released("toLeft") || Input.is_action_just_released("toRight"):
		_anim.play("soldier_idle")
	pass
pass

func _on_hurt_box_area_entered(area):
	if area.has_method("collecting"):
		area.collecting()
