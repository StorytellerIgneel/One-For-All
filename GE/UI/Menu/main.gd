extends Control

signal opened
signal closed

var isOpen: bool = false
var scene_history := []  # Stack to store the history of visited scene paths
var current_scene_path: String = "res://scenes/island.tscn"  # Variable to keep track of the current scene's file path

func _ready():
	# Set the pause mode to "Process" so this scene will still work when the game is paused
	set_process


# Function to switch to the level selection screen
func _on_level_selection_btn_pressed():
	_switch_scene("res://UI/Level_Selection/lvl_select_Background.tscn")

# Function to quit the game
func _on_quit_btn_pressed():
	get_tree().quit()

# Function to switch to the sound settings screen
func _on_sound_btn_pressed():
	_switch_scene("res://UI/Setting/sound/SoundSetting.tscn")

# Function to switch to the settings menu screen
func _on_setting_btn_pressed():
	_switch_scene("res://UI/Setting/SettingMenu.tscn")

# Function to switch to the brightness settings screen
func _on_brightness_btn_pressed():
	_switch_scene("res://UI/Setting/Brightness/brighness_ui.tscn")

# Back button logic to return to the last known screen
func _on_back_btn_pressed():
	_switch_scene("res://scenes/island.tscn")
	#if scene_history.size() > 0:
		#var last_scene = scene_history.pop_back()  # Get the last scene path and remove it from history
		#current_scene_path = last_scene  # Update the current scene path
		#get_tree().change_scene_to_file(last_scene)  # Change to the previous scene
	#else:
		#print("No previous scene to go back to.")  # Optionally return to a default screen like the main menu

# Function to switch to the keybinding settings screen
func _on_key_binds_pressed():
	_switch_scene("res://UI/Setting/KeyBinding/input_settings.tscn")

# Function to restart the current scene
func _on_restart_pressed():
	get_tree().reload_current_scene()

# Function to switch to the starting island scene
func _on_start_btn_pressed():
	_switch_scene("res://scenes/island.tscn")

# Function to make the UI visible and emit the "opened" signal
func open():
	visible = true
	isOpen = true
	opened.emit()

# Function to make the UI invisible and emit the "closed" signal
func close():
	visible = false
	isOpen = false
	closed.emit()

# Helper function to switch scenes and store the current one in the history array
func _switch_scene(new_scene_path: String):
	if current_scene_path != "":  # Ensure there's a valid current scene path to store
		scene_history.append(current_scene_path)  # Push the current scene path to the history array
	current_scene_path = new_scene_path  # Update the current scene path to the new one
	get_tree().change_scene_to_file(new_scene_path)  # Change to the new scene
