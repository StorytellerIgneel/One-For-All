extends Control

func load_next_scene():
	get_tree().change_scene_to_packed(ResourceLoader.load_threaded_get("res://scenes/island.tscn"))
