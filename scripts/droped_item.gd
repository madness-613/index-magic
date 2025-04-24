extends Control

signal slotRemoved
const ERRinvaildSlot = "Slot is not vaild for "
const slotPrefab = preload("res://scenes/slot.tscn")
var debugSlot = ["debug", null, ["debug"]]

var slots:Array[Node]
@onready var slotContainer:Control = find_child("slots")

func create(items:Array[Item]):
	for item in items:
		var i =  add_slot(Slot.fromArray(debugSlot))
		add_item(item, i)
func add_slot(slotToAdd:Slot) -> int:
	var newSlot = slotPrefab.instantiate()
	newSlot.data = slotToAdd
	newSlot.name = slotToAdd.title
	connect(slotRemoved.get_name(), newSlot.update_ID)
	newSlot.manager = self
	if slotToAdd.parent != null: slotToAdd.parent.add_child(newSlot)
	else: slotContainer.add_child(newSlot)
	slots.append(newSlot)
	newSlot.id = slots.size()-1
	Console._log("{0} Slot added to {1}".format([newSlot.data.title, get_parent().name]))
	return newSlot.id
func add_item(itemToAdd:Item, slotID:int):
	var foundSlot = slots.get(slotID)
	if foundSlot == null:
		return "slot not found"
	for tag in foundSlot.data.tags:
		if itemToAdd.vaildSlots.has(tag) or tag == "debug":
			foundSlot.held = itemToAdd
			foundSlot.update_UI()
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
func remove_slot(slotToRemove:Slot):
	for value in slots:if value.data == slotToRemove:
		remove_slot_by_ID(value.id)
		return
func remove_slot_by_ID(slotToRemove:int):
	var removedSlot:Node = slots.get(slotToRemove)
	removedSlot.queue_free()
	slots.remove_at(slotToRemove)
	slotRemoved.emit(removedSlot)
	Console._log("{0} Slot removed from {1}".format([removedSlot.data.title, get_parent().name]))
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
	if !has_items():
		self.queue_free()
	foundSlot.update_UI()
	print("{0} removed from {1}'s {2} Slot".format([removedItem.title, get_parent().name, foundSlot.data.title]))
func has_items()->bool:
	for slot in slots:
		if slot.held != null:
			return true
	return false
