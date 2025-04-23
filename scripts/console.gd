extends Node

var UiPefab:PackedScene = preload("res://scenes/console.tscn")
var UI:Window
var input:LineEdit
var output:VBoxContainer
var history:Array
var timeBack:int
var buffer

func _ready() -> void:
	UI = UiPefab.instantiate()
	UI.hide()
	add_child(UI)
	input = UI.find_child("input")
	output = UI.find_child("list")
	UI.connect("close_requested", _close_console)
	input.connect("text_submitted", _command_submited)
	input.connect("gui_input", _gui_input)
func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("open_console"):_toggle_console()

func _log(msg):
	var newLabel:Label = Label.new()
	newLabel.text = str(msg)
	print(str(msg))
	output.add_child(newLabel)
func _command_submited(text:String):
	var expression:Expression = Expression.new()
	var args:Array = text.split(" ", false, 1)
	input.text = ""
	var onRoot:bool
	for child in get_tree().root.get_children(): 
		if str(child.name) == args[0]:
			args[0]=child
			onRoot=true
			break
	if !onRoot:args[0] = get_tree().current_scene.find_child(args[0])
	var parseErr = expression.parse(args[1],["buf"])
	if parseErr != OK: _log(error_string(parseErr)+" | "+str(parseErr));	return
	print([buffer])
	var result = expression.execute([buffer], args[0])
	if !expression.has_execute_failed():
		timeBack = 0
		history.push_front(text)
		if history.size()>5:history.resize(5)
	else: _log(expression.get_error_text())
	if result != null:
		buffer = result
		_log(result)

func _gui_input(event:InputEvent):
	if event.is_action_pressed("ui_up"):
		if history.is_empty():return
		input.text = history[timeBack]
		timeBack += 1
		if timeBack>history.size()-1:timeBack=history.size()-1
	if event.is_action_pressed("ui_down"):
		if history.is_empty():return
		input.text = history[timeBack]
		timeBack -= 1
		if timeBack<0:timeBack=0
func _open_console():
	UI.show()
func _close_console():
	UI.hide()
func _toggle_console():
	if UI.get("visible"):_close_console()
	else:_open_console()
