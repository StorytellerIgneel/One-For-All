extends Control

@onready var grid_container: = %GridContainer

var num_grids = 1
var current_grid = 1
var grid_width = 548

func _ready():
	num_grids = grid_container.get_child_count()
	grid_width = grid_container.custom_minimum_size.x
	
	setup_level_box()
	
	connect_level_selected_to_level_box()
	
func setup_level_box():
	for grid in grid_container.get_children():
		for box in grid.get_children():
			box.level_num = box.get_index() + 1 + grid.get_child_count() * grid.get_index()
			box.locked = false
			
	#grid_container.get_child(0).get_child(0).locked = false
	
func 	connect_level_selected_to_level_box():
	for grid in grid_container.get_children():
		for box in grid.get_children():
			box.connect("level_selected", change_to_scene)
			
func change_to_scene(level_num: int):
	var next_level: String = "res://UI/Level_Selection/Lvls/lvl_"+ str(level_num)+".tscn"
	
	if FileAccess.file_exists(next_level): get_tree().change_scene_to_file(next_level)
			
func animatorGridPosition(finalValue):	create_tween().set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT).tween_property(grid_container, "position:x", finalValue, 0.5)

func _on_back_btn_pressed():
	get_tree().change_scene_to_file("res://UI/Menu/main.tscn")

func _on_loading_btn_pressed():
	LoadManager.load_scene("res://scenes/island.tscn")

