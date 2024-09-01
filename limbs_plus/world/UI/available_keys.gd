extends CanvasLayer


func show_key(key: String):
	if key == "h":
		$VBoxContainer/HBoxContainer/h.visible = true
	if key == "j":
		$VBoxContainer/HBoxContainer/j.visible = true
	if key == "k":
		$VBoxContainer/HBoxContainer/k.visible = true
	if key == "l":
		$VBoxContainer/HBoxContainer/l.visible = true
