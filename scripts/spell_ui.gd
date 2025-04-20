extends VSplitContainer

var active:ItemList
var activeDescirption:Node
var passive:ItemList
var passiveDescirption:Node

func _init() -> void:
	SpellDatabase.spell_learned.connect(spell_learned)
func _ready() -> void:
	active = $active/Margin/spilt/scroll/list
	activeDescirption = $active/Margin/spilt/descirption
	passive = $passive/Margin/spilt/scroll/list
	passiveDescirption = $passive/Margin/spilt/descirption
	active.item_activated.connect(Spell_Triggerd)
	active.item_selected.connect(active_spell_selected)
	passive.item_activated.connect(Spell_Triggerd)
	passive.item_selected.connect(passive_spell_selected)
func spell_learned(learned_spell:spell):
	if !self.is_node_ready(): await self.ready
	if learned_spell.type == 0: 
		var data = active.add_item(learned_spell.title, learned_spell.icon)
		active.set_item_metadata(data, learned_spell)
	else: if learned_spell.type == 1: 
		var data = passive.add_item(learned_spell.title, learned_spell.icon)
		passive.set_item_metadata(data, learned_spell)
func Spell_Triggerd(index:int):
	var data = active.get_item_metadata(index)
	print(data.title + " triggered")
	var frameWork = Node.new()
	frameWork.set_script(data.effect)
	frameWork.name = data.title + " framework"
	get_tree().current_scene.add_child(frameWork)
func active_spell_selected(index:int):
	var data = active.get_item_metadata(index)
	activeDescirption.find_child("name").set_text(data.title)
	activeDescirption.find_child("icon").set_texture(data.icon)
	activeDescirption.find_child("body").set_text(data.descirption)
func passive_spell_selected(index:int):
	var data = passive.get_item_metadata(index)
	passiveDescirption.find_child("name").set_text(data.title)
	passiveDescirption.find_child("icon").set_texture(data.icon)
	passiveDescirption.find_child("body").set_text(data.descirption)
