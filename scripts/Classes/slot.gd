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
