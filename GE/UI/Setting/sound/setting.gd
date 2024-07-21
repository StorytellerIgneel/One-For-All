extends Control


func _on_confirm_pressed():
	AudioServer.set_bus_volume_db(0, linear_to_db($AudioOptions/VBoxContainer/MasterSlider.value))
	AudioServer.set_bus_volume_db(1, linear_to_db($AudioOptions/VBoxContainer/MusicSlider.value))
	AudioServer.set_bus_volume_db(2, linear_to_db($AudioOptions/VBoxContainer/SFXSlider.value))


func _on_main_menu_btn_pressed():
	get_tree().change_scene_to_file("res://UI/Menu/main.tscn")


func _on_back_btn_pressed():
	get_tree().change_scene_to_file("res://UI/Setting/SettingMenu.tscn")
