extends Node

func _ready() -> void:
	var drop = TextureRect.new()
	drop.texture = SpellDatabase.getSpell(0).icon
	drop.name = "test drop tex"
	drop.position = get_tree().current_scene.find_child("player").position
	get_tree().current_scene.add_child(drop)
	self.queue_free()
