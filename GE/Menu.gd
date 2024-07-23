extends CanvasLayer

signal gameover

func show_gameover():
	$Button.show()

func _on_button_pressed():
	emit_signal("gameover")
	get_tree().reload_current_scene()
