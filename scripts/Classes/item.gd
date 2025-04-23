class_name Item
extends Resource

var title:String
var descirption:String
var icon:Texture
var id:int

var effect:Script
var vaildSlots:Array
var addedSlots:Array[Slot]
var heldItems:Array[Item]
var tags:Array

func copy(what:Item):
	title = what.title
	descirption = what.descirption
	icon = what.icon
	id = what.id
	effect = what.effect
	vaildSlots = what.vaildSlots
	addedSlots = what.addedSlots
	heldItems = what.heldItems
	tags = what.tags
func toJson()->Dictionary:
	var newJson := {}
	newJson.set("title", title)
	newJson.set("descirption", descirption)
	newJson.set("id", id)
	newJson.set("icon", icon.resource_path)
	if effect != null: newJson.set("script", effect.resource_path)
	else: newJson.set("script", null)
	newJson.set("vaildSlots", vaildSlots)
	var slots:Array
	for slotToCopy in addedSlots:
		slots.append(slotToCopy.toArray())
	newJson.set("addedSlots", slots)
	newJson.set("tags", tags)
	return newJson
static func fromJson(json:Dictionary)->Item:
	var newItem:= Item.new()
	newItem.title = json.title
	newItem.descirption = json.descirption
	newItem.icon = load(json.icon)
	if json.script != null: newItem.effect = load(json.script)
	newItem.id = json.id
	newItem.vaildSlots = json.vaildSlots
	for array:Array in json.addedSlots:
		var newSlot:Slot = Slot.fromArray(array)
		newItem.addedSlots.append(newSlot)
	newItem.heldItems.resize(newItem.addedSlots.size())
	newItem.tags = json.tags
	return newItem
