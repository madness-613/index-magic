extends Window

func _ready() -> void:
	position = get_tree().root.position + Vector2i(30, 30)


func _on_close_requested() -> void:
	hide()
