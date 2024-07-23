extends HSlider

func _on_value_changed(value):
	GlobalWorldEnvironment.environment.adjustment_brightness = value
	
	


func _on_back_btn_pressed():
	get_tree().change_scene_to_file("res://UI/Setting/SettingMenu.tscn")
