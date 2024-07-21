extends Control

func _on_level_selection_btn_pressed():
	get_tree().change_scene_to_file("res://UI/Level_Selection/lvl_select_Background.tscn")


func _on_quit_btn_pressed():
	get_tree().quit()


func _on_sound_btn_pressed():
	get_tree().change_scene_to_file("res://UI/Setting/sound/SoundSetting.tscn")


func _on_setting_btn_pressed():
	get_tree().change_scene_to_file("res://UI/Setting/SettingMenu.tscn")

func _on_brightness_btn_pressed():
	get_tree().change_scene_to_file("res://UI/Setting/Brightness/brighness_ui.tscn")

func _on_back_btn_pressed():
	get_tree().change_scene_to_file("res://UI/Menu/main.tscn")
