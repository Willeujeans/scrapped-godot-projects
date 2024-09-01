extends Resource
class_name Storage

@export var data: Dictionary = {}


func _init(in_data: Dictionary = {}):
	data = in_data
 

func add_data(key: String, value):
	data[key] = value


func get_data(key: String):
	if data.has(key):
		return data[key]

func erase(key: String):
	if data.has(key):
		data.erase(key)


func erase_all_data():
	data = {}

func get_all_data()-> Dictionary:
	return data


func set_all_data(in_data: Dictionary):
	data = in_data

