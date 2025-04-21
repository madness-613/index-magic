class_name slot

var title:String
var icon:Texture
var tags:Array
var parent

func copy(what:slot):
	title = what.title
	icon = what.icon
	tags = what.tags
	parent = what.parent

static func fromArray(array:Array) -> slot:
	var newSlot = slot.new()
	newSlot.title = array[0]
	newSlot.icon = load(array[1])
	for tag in array[2]: newSlot.tags.append(tag)
	return newSlot
