extends Node

signal slotAdded
signal slotRemoved
signal itemAdded
signal itemRemoved
const ERRinvaildSlot = "slot is not vaild for "

var slots:Array[Node]
var slotContainer:FlowContainer
var slotPrefab:PackedScene

func _ready() -> void:
	slotContainer = $Margin/Scroll/slots
	slotPrefab = preload("res://scenes/slot.tscn")
func add_slot(slotToAdd:slot):
	var newSlot:TextureButton = slotPrefab.instantiate()
	newSlot.data = slotToAdd
	newSlot.name = slotToAdd.title
	connect(slotRemoved.get_name(), newSlot.update_ID)
	slotContainer.add_child(newSlot)
	slots.append(newSlot)
	newSlot.id = slots.size()-1
	slotAdded.emit(newSlot)
	print("{0} slot added to {1}".format([newSlot.data.title, get_parent().name]))
func add_slots(slotsToAdd:Array[slot]):
	for newSlot in slotsToAdd:add_slot(newSlot)
func remove_slot(slotToRemove:slot):
	var removedSlot:Node
	for value in slots:if value.data == slotToRemove:
		removedSlot = value
		slots.erase(value)
		pass
	removedSlot.queue_free()
	slotRemoved.emit(removedSlot)
	print("{0} slot removed from {1}".format([removedSlot.data.title, get_parent().name]))
func remove_slot_by_ID(slotToRemove:int):
	var removedSlot:Node = slots.get(slotToRemove)
	removedSlot.queue_free()
	slots.remove_at(slotToRemove)
	slotRemoved.emit(removedSlot)
	print("{0} slot removed from {1}".format([removedSlot.data.title, get_parent().name]))
func add_item(itemToAdd:item, slotID:int):
	var foundSlot = slots.get(slotID)
	var isValid:bool
	for tag in foundSlot.data.tags:
		if itemToAdd.vaildSlots.has(tag):
			isValid = true
			pass
	if !isValid: return ERRinvaildSlot + str(itemToAdd)
	foundSlot.held = itemToAdd
	foundSlot.update_UI()
	itemAdded.emit(itemToAdd, foundSlot)
	print("{0} added to {1}'s {2} slot".format([itemToAdd.title, get_parent().name, foundSlot.data.title]))
	for newSlot in itemToAdd.addedSlots: add_slot(newSlot)
func append_item(itemToAdd:item):
	for value in slots:
		for tag in value.data.tags:
			if itemToAdd.vaildSlots.has(tag):
				value.held = itemToAdd
				value.update_UI()
				itemAdded.emit(itemToAdd, value)
				print("{0} added to {1}'s {2} slot".format([itemToAdd.title, get_parent().name, value.data.title]))
				for newSlot in itemToAdd.addedSlots: add_slot(newSlot)
				return
func remove_item(itemToRemove:item):
	for value in slots:
		if value.held == itemToRemove:
			value.held = null
			value.update_UI()
			for slotToRemove in itemToRemove.addedSlots:remove_slot(slotToRemove)
			itemRemoved.emit(itemToRemove)
			print("{0} removed from {1}'s {2} slot".format([itemToRemove.title, get_parent().name, value.data.title]))
			return
func remove_item_from_slot(slotID:int):
	var foundSlot = slots.get(slotID)
	var removedItem = foundSlot.held
	foundSlot.held = null
	foundSlot.update_UI()
	for slotToRemove in removedItem.addedSlots:remove_slot(slotToRemove)
	itemRemoved.emit(removedItem)
	print("{0} removed from {1}'s {2} slot".format([removedItem.title, get_parent().name, foundSlot.data.title]))

func has_slot_tag(tag:String) -> bool:
	for value in slots:
		if value.data.tags.has(tag):
			return true
	return false
func slot_has_slot_tag(tag:String, slotID:int) -> bool:
	var foundSlot = slots.get(slotID)
	return foundSlot.data.tags.has(tag) 
func get_slot_tags() -> Array[String]:
	var tagList:Array[String]
	for value in slots:
		tagList.append_array(value.data.tags)
	return tagList
func has_item_tag(tag:String) -> bool:
	for value in slots:
		if value.held != null:
			if value.held.tags.has(tag):
				return true
	return false
func slot_has_item_tag(tag:String, slotID:int) -> bool:
	var foundSlot = slots.get(slotID)
	if foundSlot.held != null:
		return foundSlot.held.tags.has(tag) 
	return false
func slot_type_has_item_tag(tag:String, slotType:String):
	for value in slots:
		if value.data.tags.has(slotType):
			if value.held != null:
				if value.held.tags.has(tag):
					return true
	return false
func get_item_tags() -> Array[String]:
	var tagList:Array[String]
	for value in slots:
		if value.held != null:
			tagList.append_array(value.held.tags)
	return tagList
func get_slot(what:slot) -> Node:
	var foundSlot
	for value in slots:if value.data == what:
		foundSlot = value
		pass
	return foundSlot
func get_items() -> Array[item]:
	var itemList:Array[item]
	for value in slots:
		if value.held != null:itemList.append(value.held)
	return itemList

func _on_mouse_entered() -> void:
	ItemManager.heldSlot.reparent(self)
func _on_mouse_exited() -> void:
	ItemManager.heldSlot.reparent(ItemManager)
