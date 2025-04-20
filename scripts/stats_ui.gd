extends MarginContainer

signal statAdded
signal statUpdated

var list:BoxContainer
var statBoxPrefab:PackedScene = load("res://scenes/stat_box.tscn")
var stats:Array

func  _ready() -> void:
	list = $list

func add_stat(stat:String):
	var newStat = statBoxPrefab.instantiate()
	newStat.name = stat
	newStat.find_child("name").text = stat
	stats.append(newStat)
	list.add_child(newStat)
	statAdded.emit(newStat)
func add_stats(stats:Array[String]):
	for stat in stats:
		add_stat(stat)
func set_stat(stat:String,value:float):
	var foundStat:Node
	for node in stats:
		if node.name == stat:
			foundStat = node
			pass
	foundStat.find_child("value").text = str(value)
	statUpdated.emit(foundStat, value)
func set_stats(stats:Array[String], values:Array[float]):
	var i:int = 0
	for stat in stats:
		set_stat(stat, values[i])
		i+=1
