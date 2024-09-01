extends HBoxContainer

var save_key: String = ""
signal save_was_set

func _ready():
	$SetSaveButton.text = "save "
	$SetSaveButton.text += save_key
	$SetSaveButton.text += " | time: "


func set_save_key(key: String):
	save_key = key


func _on_set_save_button_pressed():
	SaveManager.set_current_save(save_key)
	save_was_set.emit()


func _on_delete_save_button_pressed():
	SaveManager.delete_n_save(save_key)
	queue_free()
