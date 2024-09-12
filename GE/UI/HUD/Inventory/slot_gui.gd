extends Panel

@onready var backgroundSprite: Sprite2D = $background
@onready var container: CenterContainer = $CenterContainer

var itemStackGui: ItemStackGui

func insert(isg: ItemStackGui):
	itemStackGui = isg
	backgroundSprite.frame = 1
	
	container.add_child(itemStackGui)

func clear() -> void:
	if itemStackGui:
		container.remove_child(itemStackGui)
		itemStackGui = null
		
	backgroundSprite.frame = 0
