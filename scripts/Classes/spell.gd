class_name spell

var title:String
var descirption:String
var icon:Texture
var id:int

var effect:Script
var type:int
var tags:Array

func copy(what:spell):
	title = what.title
	descirption = what.descirption
	icon = what.icon
	id = what.id
	effect = what.effect
	type = what.type
	tags = what.tags
