extends Node2D

const MAX_HEALTH = 5
var health = MAX_HEALTH


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	set_health_label()
	$CanvasLayer/HealthBar.max_value = MAX_HEALTH
	set_health_bar()

func set_health_label() -> void:
		$CanvasLayer/HealthLabel.text = "Health: %s" % health
		
func set_health_bar() -> void:
	$CanvasLayer/HealthBar.value = health
	
func _input(event: InputEvent) -> void:
		if event.is_action_pressed("ui_accept"):
			damage()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func damage() -> void:
	health -= 1
	
	if health < 0:
		health = MAX_HEALTH
	set_health_label()
	set_health_bar()
