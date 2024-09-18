extends Area2D

var has_given_key = false
var player_in_area = null

# Called when the node enters the scene tree for the first time.
func _ready():
	connect("_on_tree_2_area_body_entered", Callable(self, "_on_body_entered"))
	connect("_on_tree_2_area_body_exited", Callable(self, "_on_body_exited"))
	
	print("Tree2Area ready and signals connected")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if player_in_area and Input.is_action_just_pressed("Interact"):
		_give_key()

func action():
	if get_parent().hasKey == true and Global.findingKey == 1:
		Global.findingKey = 2 #finding second key now
		Global.trigger_dialogue("res://Dialogues/Key1.dialogue", "start")
	elif get_parent().hasKey == true and Global.findingKey != 3:
		Global.trigger_dialogue("res://Dialogues/wrongKey.dialogue", "start")
	else: #no key
		Global.trigger_dialogue("res://Dialogues/PlainItemsNoKey.dialogue", "start")

func _give_key():
	if not has_given_key:
		has_given_key = true
		print("Key given to player!")
		
		if player_in_area.has_method("add_key_to_inventory"):
			player_in_area.add_key_to_inventory()
		else:
			print("Player does not have add_key_to_inventory method")

func _on_body_entered(body):
	if body.is_in_group("player"):
		player_in_area = body
	
		print("Player enterd tree area")
				
func _on_body_exited(body):
	if body == player_in_area:
		player_in_area = null
