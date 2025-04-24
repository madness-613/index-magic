extends BoxContainer

var UIUpdated:Signal

var id:int
var data:Slot
var held:Item
var manager:Node
var iconUi:TextureRect 
var itemUi:TextureRect 

func _ready() -> void:
	iconUi = $slot/icon
	itemUi = $slot/item
	iconUi.texture = data.icon
	update_UI()
func update_UI():
	if held == null:
		iconUi.set("visible", true)
		itemUi.set("visible", false)
	else: 
		itemUi.texture = held.icon
		iconUi.set("visible", false)
		itemUi.set("visible", true)
	UIUpdated.emit()
func update_ID(_removedSlot:Node):
	id = manager.slots.find(self)
func _on_pressed() -> void:
	if held == null:
		if ItemManager.HeldItem != null:
			var err = manager.add_item(ItemManager.HeldItem, id)
			if err != null:return
			ItemManager.holdItem(null)
	else:
		if ItemManager.HeldItem == null:
			ItemManager.holdItem(held)
			manager.remove_item_from_slot(id, true)
