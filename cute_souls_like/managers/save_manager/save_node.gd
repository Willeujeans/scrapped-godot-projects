@tool
extends Node
@export var generate_new_save_key: bool:
	set(value):
		generate_new_save_key = true
		if Engine.is_editor_hint():
			if !get("has_key"):
				generate_unique_identifier()
			else:
				delete_stored_data()
				set("has_key", false)
				generate_unique_identifier()
@export_group("Options")
@export var display_text: bool = true
@export var save_active: bool = true
@export_group("Advanced Options")
@export var key_size: int = 16
@export var handle_collisions: bool = false
@export_group("ReadOnly")
@export var readable_name: String:
	get:
		return readable_name
	set(value):
		if !get("has_key"):
			readable_name = value
@export var unique_key: String:
	get:
		return unique_key
	set(value):
		if !get("has_key"):
			unique_key = value
@export var id: String:
	get:
		return id
	set(value):
		if !get("has_key"):
			id = value
@export var has_key: bool = false

func _ready():
	if not Engine.is_editor_hint():
		load_saved_variables()


func generate_unique_identifier():
	if Engine.is_editor_hint():
		# if you only get parent name when parent is available the code does not work
		set("readable_name", get_parent().name)
		set("unique_key", generate_random_key(key_size))
		var new_id = readable_name + unique_key
		if handle_collisions:
			if has_collisions(new_id):
				generate_unique_identifier()
		set("id", new_id)
		set("has_key", true)


func has_collisions(id):
	for each in get_tree().get_nodes_in_group("save_node"):
		if id == each.get("id"):
			return true
	return false


func generate_random_key(key_size: int = 16, starting_character: String = "")-> String:
	var characters: String = "0123456789abcdefghijklmnopqrstuvwxyz"
	var key: String = starting_character
	var n_char: int = len(characters)
	for i in range(key_size):
		key += characters[randi()% n_char]
	return key


func get_key()-> String:
	return id


func load_saved_variables():
	if !save_active and !Engine.is_editor_hint():
		return
	if display_text: print("save_node<" + unique_key.left(3) + "> | loading data...")	
	if SaveManager.get_data(id):
		var loaded_data = SaveManager.get_data(id)
		for each in loaded_data:
			var variable_name = each.get("name")
			var variable_value = each.get("value")
			if display_text: print("save_node<" + unique_key.left(3) + "> | " + str(variable_name) + " = " + str(variable_value))
			get_parent().set(variable_name, variable_value)
		if display_text: print("save_node<" + unique_key.left(3) + "> | loaded data.")	


func get_saved_variables():
	if not Engine.is_editor_hint():
		if display_text: print("save_node<" + unique_key.left(3) + "> | sending data...")
		if get_parent().get_script():
			var name_of_variables_to_save = get_parent().get_script().get_script_property_list()
			var data_to_save = []
			for each in name_of_variables_to_save:
				if each.get("usage") != 4102: # this excludes export variables
					var variable_name = each.get("name")
					var variable_value = get_parent().get(variable_name)
					if variable_value != null and variable_name != null:
						if display_text: print("save_node<" + unique_key.left(3) + "> | " + str(variable_name) + ": " + str(variable_value))
						data_to_save.append({"name" : variable_name , "value" : variable_value})
			if display_text: print("save_node<" + unique_key.left(3) + "> | sent data.")
			return data_to_save


func delete_stored_data():
	if id:
		SaveManager.delete_save_node_data(id)
