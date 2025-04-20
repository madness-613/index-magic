extends  Node

var spells:Dictionary[int,spell]
var knownSpells:Dictionary[int,spell]
signal spell_added(added_spell:spell)
signal spell_learned(learned_spell:spell)
signal database_loaded()


func _ready() -> void:
	for file in DirAccess.get_files_at("res://data/spells"):
		var data = JSON.parse_string(FileAccess.open("res://data/spells/"+file, FileAccess.READ).get_as_text())
		var newSpell:spell = spell.new()
		newSpell.title = data.title
		newSpell.descirption = data.descirption
		newSpell.icon = load(data.icon)
		newSpell.effect = load(data.script)
		newSpell.id = data.id
		newSpell.type = data.type
		newSpell.tags = data.tags
		addSpell(newSpell)
		addKnownSpell(newSpell)
	database_loaded.emit()
func addSpell(spellToAdd:spell):
	if(spells.has(spellToAdd.id)):
		printerr("a spell with id '"+ str(spellToAdd.id) +"' is already in database")
		return
	spells.set(spellToAdd.id, spellToAdd)
	print("added: " + spellToAdd.title + " to database")
	spell_added.emit(spellToAdd)
func getSpell(spellToFind:int) -> spell:
	var foundSpell = spells.get(spellToFind)
	if(foundSpell != null):return foundSpell
	else: 
		print("no spell with id '" + str(spellToFind) + "' in database")
		return
func addKnownSpell(spellToAdd:spell):
	if(knownSpells.has(spellToAdd.id)):
		printerr("a spell with id '"+ str(spellToAdd.id) +"' is already known")
		return
	knownSpells.set(spellToAdd.id, spellToAdd)
	print("added: " + spellToAdd.title + " to known spells")
	spell_learned.emit(spellToAdd)
func getKnownSpell(spellToFind:int) -> spell:
	var foundSpell = knownSpells.get(spellToFind)
	if(foundSpell != null):return foundSpell
	else: 
		print("no spell with id '" + str(spellToFind) + "' is known")
		return null
