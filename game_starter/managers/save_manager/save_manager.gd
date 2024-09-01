@tool
extends Node

const SAVE_PATH: String = "user://saves/"
var current_save_path: String
var current_storage: Storage
var list_of_saves: Array


func _ready():
	if !Engine.is_editor_hint():
		check_for_save_folder()
		check_for_saves()


# getters
func get_data(key):
	if current_storage.get_data(key):
		return current_storage.get_data(key)


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


# setters
func set_current_save(key: String):
	print("save_data_manager | setting current save [" + key + "]")
	current_save_path = SAVE_PATH + "save" + key + ".tres"


func set_current_storage(new_storage: Storage):
	current_storage = new_storage


func delete_n_save(key: String):
	DirAccess.remove_absolute(SAVE_PATH + "save" + key + ".tres")
	check_for_saves()


func delete_all_saves():
	for each in get_files_in_folder(SAVE_PATH):
		DirAccess.remove_absolute(each)


func generate_random_key(key_size: int = 16, starting_character: String = "")-> String:
	var characters: String = "0123456789abcdefghijklmnopqrstuvwxyz"
	var key: String = starting_character
	var n_char: int = len(characters)
	for i in range(key_size):
		key += characters[randi()% n_char]
	return key


func check_for_save_folder():
	var dir = DirAccess.open("user://")
	if !dir.dir_exists(SAVE_PATH):
		print("save_data_manager | checking for save folder [false]")
		print("save_data_manager | creating save folder [" + SAVE_PATH + "]")
		dir.make_dir(SAVE_PATH)
	else:
		print("save_data_manager | checking for save folder [true]")


func check_for_saves():
	list_of_saves = get_files_in_folder(SAVE_PATH)


func create_new_save(save_key: String = generate_random_key(4)):
	check_for_saves()
	if !list_of_saves.is_empty():
		for each in list_of_saves:
			if save_key == ResourceLoader.load(each).get_data("save_key"):
				return ""

	print("save_data_manager | creating new save [" + save_key + "]")	
	set_current_save(save_key)
	var new_storage = Storage.new()
	new_storage.add_data("save_key", save_key)
	ResourceSaver.save(new_storage, current_save_path)
	set_current_storage(new_storage)
	print("save_data_manager | created save file [ " + current_save_path + " ]")	
	check_for_saves()
	return save_key


func add_to_save(key: String, value):
	current_storage.add_data(key, value)


func write_save_to_disc():
	ResourceSaver.save(current_storage, current_save_path)


func save_all_nodes():
	for node in get_tree().get_nodes_in_group("save_node"):
		if node.save_active:
			current_storage.add_data(node.get_key(), node.get_saved_variables())


func load_all_nodes():
	for node in get_tree().get_nodes_in_group("save_node"):
		node.load_saved_variables()


func save_current_game():
	print("save_data_manager | saving game...")
	save_all_nodes()
	write_save_to_disc()
	print("save_data_manager | saved game.")


func load_current_save():
	print("save_data_manager | loading game [" + current_save_path + "]")
	current_storage = ResourceLoader.load(current_save_path)
	load_all_nodes()
	print("save_data_manager | loaded game.")


func delete_save_node_data(key: String):
	if Engine.is_editor_hint():
		print("save_data_manager | deleting data from <" + key + ">")
		current_storage.erase(key)
		print("save_data_manager | deleted data.")
