extends HBoxContainer

# Use Array to store btns
var skills : Array
@onready var debug = $"../debug"
 
func _ready():
	skills = get_children()
	for i in get_child_count():
		skills[i].change_key = str(i+1)
 
 
func _casted(spell_name):
	debug.text = spell_name
