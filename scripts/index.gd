extends Window

func _ready() -> void:
	position = get_tree().root.position + Vector2i(30, 30)


func _on_close_requested() -> void:
	hide()

func _on_window_input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"):hide()
	if event.is_action_pressed("open_index"):hide()
