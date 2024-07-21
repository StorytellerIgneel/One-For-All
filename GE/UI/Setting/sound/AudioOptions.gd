extends Control

func _ready():
	# AudioServer.get_bus_volume_db(0) - is to specify their position no.
	$VBoxContainer/MasterSlider.value = db_to_linear(AudioServer.get_bus_volume_db(0))
	$VBoxContainer/MusicSlider.value = db_to_linear(AudioServer.get_bus_volume_db(1))
	$VBoxContainer/SFXSlider.value = db_to_linear(AudioServer.get_bus_volume_db(2))
	
func _on_master_slider_mouse_exited():
	release_focus()
	
func _on_music_slider_mouse_exited():
	release_focus()

func _on_sfx_slider_mouse_exited():
	release_focus()
