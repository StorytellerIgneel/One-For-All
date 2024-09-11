extends CanvasLayer

@onready var settingScreen = $SettingMenu

func _ready():
	settingScreen.close()
	
func _input(event):
	if event.is_action_pressed("Setting"):
		if settingScreen.isOpen:
			settingScreen.close()
		else:
			settingScreen.open()
