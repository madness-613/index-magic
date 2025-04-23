class_name Slot
extends Resource

var title:String
var icon:Texture
var tags:Array
var parent

func copy(what:Slot):
	title = what.title
	icon = what.icon
	tags = what.tags
	parent = what.parent

static func fromArray(array:Array) -> Slot:
	var newSlot = Slot.new()
	newSlot.title = array[0]
	if array[1] != null:
		print(array[1])
		newSlot.icon = load(array[1])
	else: 
		newSlot.icon = load("res://data/art/icons/blank.png")
	for tag in array[2]:
		newSlot.tags.append(tag)
	return newSlot
func toArray() -> Array:
	var array:Array
	array.append(title)
	if icon != null: array.append(icon.resource_path)
	else: array.append(null)
	array.append(tags)
	return array
		
	
