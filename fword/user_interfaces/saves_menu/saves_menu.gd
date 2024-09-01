extends VBoxContainer
@export var select_save_button_scene: PackedScene
@export var next_scene: PackedScene
var save_button_list: Array = []

func _ready():
	create_save_buttons()


func create_save_buttons():
	if !SaveManager.list_of_saves.is_empty():
		for each in SaveManager.list_of_saves:
			var select_save_button = select_save_button_scene.instantiate()
			var key = ResourceLoader.load(each).get_data("save_key")
			select_save_button.set_save_key(key)
			select_save_button.connect("save_was_set", func(): $SceneChangeNode.go_next_scene())
			add_child(select_save_button)
			save_button_list.append(select_save_button)


func _on_new_save_button_pressed():
	var select_save_button = select_save_button_scene.instantiate()
	select_save_button.set_save_key(SaveManager.create_new_save(str(SaveManager.get_number_of_saves())))
	add_child(select_save_button)
	save_button_list.append(select_save_button)
	select_save_button.connect("save_was_set", func(): $SceneChangeNode.go_next_scene())


func _on_delete_all_saves_pressed():
	for each in save_button_list:
		if each:
			each.queue_free()
	SaveManager.delete_all_saves()
