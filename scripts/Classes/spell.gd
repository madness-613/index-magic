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
static  func fromJson(json:Dictionary)->spell:
	var newSpell:spell = spell.new()
	newSpell.title = json.title
	newSpell.descirption = json.descirption
	newSpell.icon = load(json.icon)
	newSpell.effect = load(json.script)
	newSpell.id = json.id
	newSpell.type = json.type
	newSpell.tags = json.tags
	return newSpell
