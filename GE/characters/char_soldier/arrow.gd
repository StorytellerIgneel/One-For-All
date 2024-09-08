extends Area2D

var speed = 300

# Called when the node enters the scene tree for the first time.
func _ready():
	set_as_top_level(true)
	var soldier = get_tree().get_node("soldierV2")
	var arrow_damage = soldier.soldier_atk3dmg


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	position += (Vector2.RIGHT*speed).rotated(rotation) * delta

func _on_visible_on_screen_enabler_2d_screen_exited():
	queue_free()


func _on_area_entered(area):
	#area(arrow_damage)
	pass
