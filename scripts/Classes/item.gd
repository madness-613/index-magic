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
