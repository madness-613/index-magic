extends Node

var data:spell

func _ready() -> void:
	var drop = TextureRect.new()
	drop.texture = data.icon
	drop.name = "test drop tex"
	drop.position = get_parent().position
	get_tree().current_scene.add_child(drop)
	self.queue_free()
