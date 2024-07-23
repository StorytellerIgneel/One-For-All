extends Control

@onready var input_button_scene  = preload("res://UI/Setting/KeyBinding/input_btn.tscn")
@onready var action_list = $Panel/MarginContainer/VBoxContainer/ScrollContainer/ActionList

var is_remapping = false
var action_to_remap = null
var remapping_button = null

var input_actions = {
	"toUp" : "Move up",
	"toDown" : "Move Down",
	"toLeft" : "Move Lown",
	"toRight" : "Move Right"
}

func _ready():
	_create_action_list()

func _create_action_list():
	InputMap.load_from_project_settings()

	# Clear any existing children
	for item in action_list.get_children():
		item.queue_free()

	# Add buttons for each action
	for action in input_actions.keys():
		var button = input_button_scene.instantiate()
		var action_label = button.find_child("LabelAction")
		var input_label = button.find_child("LabelInput")

		action_label.text = input_actions[action]

		var events = InputMap.action_get_events(action)

		if events.size() > 0:
			input_label.text = events[0].as_text().trim_prefix(" (Physical)")
		else:
			input_label.text = ""

		action_list.add_child(button)

		button.pressed.connect(_on_input_button_pressed.bind(button, action))

func _on_input_button_pressed(button, action):
	if !is_remapping:
		is_remapping = true
		action_to_remap = action
		remapping_button = button
		button.find_child("LabelInput").text =  "Press Key To Bind..."

func _input(event):
	if is_remapping:
		if(
			event is InputEventKey || 
			(event is InputEventMouseButton && event.pressed)
		):
			InputMap.action_erase_events(action_to_remap)
			InputMap.action_add_event(action_to_remap, event)
			_update_action_list(remapping_button, event)

			is_remapping = false
			action_to_remap = null
			remapping_button = null

func _update_action_list(button, event):
	button.find_child("LabelInput").text = event.as_text().trim_suffix( "(Physical)")

func _on_button_pressed():
	get_tree().change_scene_to_file("res://UI/Setting/SettingMenu.tscn")
