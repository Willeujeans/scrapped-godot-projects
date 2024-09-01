extends Resource
class_name SettingsData

@export var data: Dictionary = {}

func _init(in_data):
	data = in_data


func get_data(key):
	return data[key]


func get_all_data()-> Dictionary:
	return data
