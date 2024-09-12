extends Node

var level_times = {}
@export var save_data_name: String = "saved_times"
const SAVE_PATH: String = "user://saves/"
var save_data_resource


func _ready():
	print(OS.get_data_dir())
	check_for_save_folder()
	if get_number_of_saves() == 0:
		print("Number of saves: ", get_number_of_saves())
		save_data_resource = SaveData.new()
		save_data_to_disc()
	else:
		print("Number of saves: ", get_number_of_saves())
		load_data_on_disc()


func load_data_on_disc():
	save_data_resource = ResourceLoader.load(SAVE_PATH + "/" + save_data_name + ".tres")
	level_times = save_data_resource.data


func save_data_to_disc():
	save_data_resource.data = level_times
	ResourceSaver.save(save_data_resource, SAVE_PATH + "/" + save_data_name + ".tres")


func check_for_save_folder():
	var dir = DirAccess.open("user://")
	if !dir.dir_exists(SAVE_PATH):
		print("creating save folder [" + SAVE_PATH + "]")
		dir.make_dir(SAVE_PATH)
	else:
		print("checking for save folder [true]")


func get_number_of_saves():
	return get_files_in_folder(SAVE_PATH).size()


func get_files_in_folder(path: String)->Array:
	var files = []
	var directory = DirAccess.open(path)
	if directory:
		directory.list_dir_begin()
		var file_name = directory.get_next()
		while file_name != "":
			files.append(path + file_name)
			file_name = directory.get_next()
	else:
		print("save_data_manager | ERROR: could not access path [" + path +"]")
	return files

