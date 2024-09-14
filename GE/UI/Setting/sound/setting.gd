extends Control

# Stack to store the history of visited scene paths
var scene_history := []
var current_scene_path: String = "res://UI/Setting/SoundSetting.tscn"  # The current scene

func _ready():
	# Optionally store the current scene when entering this scene
	# Assuming this scene is entered from another scene
	if current_scene_path != "":
		scene_history.append(current_scene_path)

# Function to confirm and set audio settings
func _on_confirm_pressed():
	AudioServer.set_bus_volume_db(0, linear_to_db($AudioOptions/VBoxContainer/MasterSlider.value))
	AudioServer.set_bus_volume_db(1, linear_to_db($AudioOptions/VBoxContainer/MusicSlider.value))
	AudioServer.set_bus_volume_db(2, linear_to_db($AudioOptions/VBoxContainer/SFXSlider.value))

# Function to go to the main menu
func _on_main_menu_btn_pressed():
	_switch_scene("res://UI/Menu/main.tscn")

# Function to go back to the last known scene
func _on_back_btn_pressed():
	if scene_history.size() > 0:
		var last_scene = scene_history.pop_back()  # Get the last scene path and remove it from history
		get_tree().change_scene_to_file(last_scene)  # Change to the previous scene
	else:
		print("No previous scene to go back to.")
		_switch_scene("res://UI/Menu/main.tscn")  # Fallback to main menu if no history exists

# Helper function to switch scenes and store the current one in the history
func _switch_scene(new_scene_path: String):
	if current_scene_path != "":
		scene_history.append(current_scene_path)  # Store the current scene in history
	current_scene_path = new_scene_path  # Update the current scene path
	get_tree().change_scene_to_file(new_scene_path)  # Change to the new scene
