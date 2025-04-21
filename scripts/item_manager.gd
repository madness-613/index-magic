extends Node

var items:Dictionary[int,item]
var inventories:Array[Node]
var heldSlot:TextureRect = TextureRect.new()
var HeldItem:item
signal database_loaded()

func _ready() -> void:
	heldSlot.modulate.a8 = 128
	heldSlot.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	heldSlot.size = Vector2(64,64)
	heldSlot.name = "held item"
	heldSlot.mouse_filter = Control.MOUSE_FILTER_IGNORE
	heldSlot.z_index = 1
	heldSlot.z_as_relative = false
	add_child(heldSlot)
	for file in DirAccess.get_files_at("res://data/items"):
		var data = JSON.parse_string(FileAccess.open("res://data/items/"+file, FileAccess.READ).get_as_text())
		var newitem:item = item.fromJson(data)
		addItem(newitem)
	database_loaded.emit()
func _process(_delta: float) -> void:
	heldSlot.set_position(heldSlot.get_global_mouse_position()-heldSlot.size/2)

func addItem(itemToAdd:item):
	if items.has(itemToAdd.id):
		printerr("a item with id '"+ str(itemToAdd.id) +"' is already in database")
		return
	else: 
		items.set(itemToAdd.id, itemToAdd)
		print(itemToAdd.title + " added to database")
func getItem(id:int) -> item:
	var foundItem:item = items.get(id)
	if foundItem != null: 
		var itemBuffer:item = item.new()
		itemBuffer.copy(foundItem)
		return itemBuffer
	else:
		printerr("no item with id '" + str(id) + "' found in database")
		return null
func holdItem(what:item):
	HeldItem = what
	if what == null: heldSlot.texture = null
	else: heldSlot.texture = what.icon
