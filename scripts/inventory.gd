extends Node

signal slotAdded
signal slotRemoved
signal itemAdded
signal itemRemoved
const ERRinvaildSlot = "Slot is not vaild for "
const slotPrefab = preload("res://scenes/slot.tscn")

var slots:Array[Node]
@onready var slotContainer:Control = find_child("slots", true)

func add_slot(slotToAdd:Slot) -> int:
	var newSlot = slotPrefab.instantiate()
	newSlot.data = slotToAdd
	newSlot.name = slotToAdd.title
	connect(slotRemoved.get_name(), newSlot.update_ID)
	if slotToAdd.parent != null and !slotToAdd.tags.has("bag"): slotToAdd.parent.add_child(newSlot)
	else: slotContainer.add_child(newSlot)
	slots.append(newSlot)
	newSlot.id = slots.size()-1
	slotAdded.emit(newSlot)
	Console._log("{0} Slot added to {1}".format([newSlot.data.title, get_parent().name]))
	return newSlot.id
func add_slots(slotsToAdd:Array[Slot]):
	for newSlot in slotsToAdd:add_slot(newSlot)
func remove_slot(slotToRemove:Slot):
	var removedSlot:Node
	for value in slots:if value.data == slotToRemove:
		remove_slot_by_ID(value.id)
		return
func remove_slot_by_ID(slotToRemove:int):
	var removedSlot:Node = slots.get(slotToRemove)
	removedSlot.queue_free()
	slots.remove_at(slotToRemove)
	slotRemoved.emit(removedSlot)
	Console._log("{0} Slot removed from {1}".format([removedSlot.data.title, get_parent().name]))
func add_item(itemToAdd:Item, slotID:int):
	var foundSlot = slots.get(slotID)
	for tag in foundSlot.data.tags:
		if itemToAdd.vaildSlots.has(tag) or tag == "debug":
			foundSlot.held = itemToAdd
			foundSlot.update_UI()
			itemAdded.emit(itemToAdd, foundSlot)
			Console._log("{0} added to {1}'s {2} Slot".format([itemToAdd.title, get_parent().name, foundSlot.data.title]))
			var i=0
			for newSlot in itemToAdd.addedSlots: 
				newSlot.parent = foundSlot
				var addedSlot = add_slot(newSlot)
				var helditem = itemToAdd.heldItems.get(i)
				if helditem != null:
					add_item(helditem, addedSlot)
				i+=1
			if foundSlot.data.parent != null:
				var spot = foundSlot.data.parent.held.addedSlots.find(foundSlot.data)
				foundSlot.data.parent.held.heldItems.set(spot,itemToAdd)
			return
	return ERRinvaildSlot + str(itemToAdd)
func add_items(itemsToAdd:Array[Item], slotIDs:Array[int]):
	var i=0
	for itemToAdd in itemsToAdd:
		add_item(itemToAdd, slotIDs[i])
		i+=1
func append_item(itemToAdd:Item):
	var i:int=0
	for value in slots:
		if value.held == null:
			for tag in value.data.tags:
				if itemToAdd.vaildSlots.has(tag) or tag == "debug":
					add_item(itemToAdd, i)
					return
		i+=1
func append_items(itemsToAdd:Array[Item]):
	for itemToAdd in itemsToAdd:
		append_item(itemToAdd)
func remove_item(itemToRemove:Item, removeFromParent:bool):
	for value in slots:
		if value.held == itemToRemove:
			remove_item_from_slot(value.id,removeFromParent)
			return
func remove_item_from_slot(slotID:int, removeFromParent:bool):
	var foundSlot = slots.get(slotID)
	var removedItem = foundSlot.held
	for heldItem in removedItem.heldItems:
		if heldItem != null:
			remove_item(heldItem, false)
	for slotToRemove in removedItem.addedSlots:
		remove_slot(slotToRemove)
	if foundSlot.data.parent != null and removeFromParent:
		var parentItems:Array = foundSlot.data.parent.held.heldItems
		parentItems.set(parentItems.find(removedItem), null)
	foundSlot.held = null
	foundSlot.update_UI()
	itemRemoved.emit(removedItem)
	print("{0} removed from {1}'s {2} Slot".format([removedItem.title, get_parent().name, foundSlot.data.title]))

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
func get_slot(what:Slot) -> Node:
	var foundSlot
	for value in slots:if value.data == what:
		foundSlot = value
		pass
	return foundSlot
func get_items() -> Array[Item]:
	var itemList:Array[Item]
	for value in slots:
		if value.held != null:itemList.append(value.held)
	return itemList
func get_slot_from_item(what:Item) -> Node:
	for value in slots:
		if value.held == what:
			print(value.name)
			return value
	return null

func _on_mouse_entered() -> void:
	ItemManager.heldSlot.reparent(self)
func _on_mouse_exited() -> void:
	ItemManager.heldSlot.reparent(ItemManager)
