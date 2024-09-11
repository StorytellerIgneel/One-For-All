extends CanvasLayer

signal loading_screen_has_full_coverage

@onready var animationPlayer : AnimationPlayer = $AnimationPlayer
@onready var progressBar : ProgressBar = $Panel/ProgressBar
@onready var panel : Panel = $Panel

func _update_progress_bar(new_value: float) -> void:
	progressBar.set_value_no_signal(new_value * 100)
	
func _start_outro_animation() -> void:
	animationPlayer.play("end_load")
	await  Signal(animationPlayer, "animation_finished")
	# Remove loading screen from the game
	self.queue_free()
	
func _start_intro_animation() ->  void:
	animationPlayer.play("start_load")
	emit_signal("loading_screen_has_full_coverage")
	
