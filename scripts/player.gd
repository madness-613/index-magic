extends CharacterBody2D

@export var HP:int
@export var MaxHP:int
@export var speed:float
var direction:Vector2 
var index:Window
var statsUI:Node
var inventory:Window

func  _ready() -> void:
	index = get_tree().current_scene.find_child("index")
	statsUI = index.find_child("stats")
	inventory = find_child("inventory")
	inventory.connect("itemRemoved", check_index)
	inventory.connect("close_requested", close_inventory)
	inventory.connect("window_input", _unhandled_input)
	#basic stats
	var baseStats:Dictionary[String, float] = {"con":100,"dex":1,"magic":1}
	statsUI.add_stats(baseStats.keys())
	statsUI.set_stats(baseStats.keys(), baseStats.values())
	var baseSlotsJson = JSON.parse_string(FileAccess.open("res://json/baseSlots.json", FileAccess.READ).get_as_text())
	for data in baseSlotsJson:
		if data.type == "player":
			for baseSlot in data.slots:
				inventory.add_slot(Slot.fromArray(baseSlot))
			break
	ItemManager.dropItem(ItemManager.getItem(0), Vector2(0,0))
	ItemManager.dropItems(ItemManager.getItems(), Vector2(0,50))
	inventory.position = get_tree().root.position
	inventory.position += Vector2i(get_global_transform_with_canvas().get_origin())-inventory.size/2
	
func _physics_process(_delta: float) -> void:
	direction = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	velocity = direction*(speed*500)
	look_at(transform.origin + velocity)
	move_and_slide()
func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("open_index"): toggle_index()
	if event.is_action_pressed("open_inventory"): toggle_inventory()

func open_index():
	if inventory.slot_type_has_item_tag("index", "hand") || inventory.slot_type_has_item_tag("index", "ring"):
		index.show()
func close_index():
	index.hide()
func toggle_index():
	if index.get("visible"):close_index()
	else: open_index()
func check_index(_removedItem:Item):
	if !inventory.slot_type_has_item_tag("index", "hand") || !inventory.slot_type_has_item_tag("index", "ring"):
		close_index()
func open_inventory():
	inventory.show()
func close_inventory():
	inventory.hide()
func toggle_inventory():
	if inventory.get("visible"):close_inventory()
	else:open_inventory()
