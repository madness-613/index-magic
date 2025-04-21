class_name item

var title:String
var descirption:String
var icon:Texture
var id:int

var effect:Script
var vaildSlots:Array
var addedSlots:Array[slot]
var heldItems:Array[item]
var tags:Array

func copy(what:item):
	title = what.title
	descirption = what.descirption
	icon = what.icon
	id = what.id
	effect = what.effect
	vaildSlots = what.vaildSlots
	addedSlots = what.addedSlots
	heldItems = what.heldItems
	tags = what.tags
static func fromJson(json:Dictionary)->item:
	var newItem:item = item.new()
	newItem.title = json.title
	newItem.descirption = json.descirption
	newItem.icon = load(json.icon)
	if json.script != null: newItem.effect = load(json.script)
	newItem.id = json.id
	newItem.vaildSlots = json.vaildSlots
	for array:Array in json.addedSlots:
		var newSlot:slot = slot.fromArray(array)
		newItem.addedSlots.append(newSlot)
	newItem.heldItems.resize(newItem.addedSlots.size())
	newItem.tags = json.tags
	return newItem
