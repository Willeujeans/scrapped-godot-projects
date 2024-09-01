extends HBoxContainer


var save_key: String = ""
signal save_was_set

func _ready():
	$SetSaveButton.text = "save " + save_key + ": * " + str(ResourceLoader.load(SaveManager.SAVE_PATH + "save" + save_key + ".tres").get_data("total_stars"))


func set_save_key(key: String):
	save_key = key


func _on_set_save_button_pressed():
	SaveManager.set_current_save(save_key)
	save_was_set.emit()


func _on_delete_save_button_pressed():
	SaveManager.erase_n_save(save_key)
