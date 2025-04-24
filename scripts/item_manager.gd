extends Node

const dropedItemPrefab = preload("res://scenes/droped_item.tscn")
var debugSlot = Slot.fromArray(["debug", null, ["debug"]])

var items:Dictionary[int,Item]
var dropedItems:Array[Node]
var heldSlot:TextureRect = TextureRect.new()
var HeldItem:Item
signal database_loaded()

func _ready() -> void:
	heldSlot.modulate.a8 = 128
	heldSlot.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	heldSlot.size = Vector2(64,64)
	heldSlot.name = "held Item"
	heldSlot.mouse_filter = Control.MOUSE_FILTER_IGNORE
	heldSlot.z_index = 1
	heldSlot.z_as_relative = false
	add_child(heldSlot)
	for file in DirAccess.get_files_at("res://data/items"):
		var data = JSON.parse_string(FileAccess.open("res://data/items/"+file, FileAccess.READ).get_as_text())
		var newitem:Item = Item.fromJson(data)
		addItem(newitem)
	database_loaded.emit()
func _process(_delta: float) -> void:
	heldSlot.set_position(heldSlot.get_global_mouse_position()-heldSlot.size/2)

func addItem(itemToAdd:Item):
	if items.has(itemToAdd.id):
		printerr("a Item with id '"+ str(itemToAdd.id) +"' is already in database")
		return
	else: 
		items.set(itemToAdd.id, itemToAdd)
		print(itemToAdd.title + " added to database")
func getItem(id:int) -> Item:
	var foundItem:Item = items.get(id)
	if foundItem != null: 
		return Item.fromJson(foundItem.toJson())
	else:
		printerr("no Item with id '" + str(id) + "' found in database")
		return null
func getItems() -> Array[Item]:
	var list:Array[Item]
	for item in items.values():
		list.append(Item.fromJson(item.toJson()))
	return list
func holdItem(what:Item):
	HeldItem = what
	if what == null: heldSlot.texture = null
	else: heldSlot.texture = what.icon
	
func dropItems(what:Array[Item], whare:Vector2) -> Control:
	var dropedItem = dropedItemPrefab.instantiate()
	get_tree().current_scene.add_child.call_deferred(dropedItem)
	await dropedItem.ready
	dropedItem.position = whare
	dropedItem.create(what)
	dropedItems.append(dropedItem)
	return dropedItem
