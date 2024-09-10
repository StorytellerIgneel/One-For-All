extends Control

@onready var grid_container: = %GridContainer

var num_grids = 1
var current_grid = 1
var grid_width = 548

# Dictionary mapping level numbers to their corresponding scene file names
var level_scenes = {
	1: "res://scenes/island.tscn",
	2: "res://plain.tscn",
	3: "res://scenes/beach.tscn",
	4: "res://scenes/winterfell.tscn",
	5: "res://scenes/volcano.tscn"
}

func _ready():
	num_grids = grid_container.get_child_count()
	grid_width = grid_container.custom_minimum_size.x

	setup_level_box()
	
	connect_level_selected_to_level_box()

func setup_level_box():
	for grid in grid_container.get_children():
		for box in grid.get_children():
			# Adjusted level numbering and ensure it's within the level_scenes map
			# calculate the level number for each box within a grid inside the grid_container
			var level_num = box.get_index() + 1 + grid.get_child_count() * grid.get_index()
			if level_scenes.has(level_num):
				box.level_num = level_num
				box.locked = false  # You can modify this if certain levels should remain locked
			else:
				box.locked = true  # Lock boxes for levels not present in the dictionary

func connect_level_selected_to_level_box():
	for grid in grid_container.get_children():
		for box in grid.get_children():
			box.connect("level_selected", change_to_scene)

func change_to_scene(level_num: int):
	
	# Use the level_scenes dictionary to get the correct scene based on the level number
	if level_scenes.has(level_num):
		var next_level = level_scenes[level_num]
		
		if FileAccess.file_exists(next_level):
			get_tree().change_scene_to_file(next_level)
	else:
		print("Level does not exist for level number: ", level_num)
		
func animatorGridPosition(finalValue):
	create_tween().set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT).tween_property(grid_container, "position:x", finalValue, 0.5)

func _on_back_btn_pressed():
	get_tree().change_scene_to_file("res://UI/Menu/main.tscn")

#func _on_loading_btn_pressed():
		#LoadManager.load_scene("res://scenes/island.tscn")
