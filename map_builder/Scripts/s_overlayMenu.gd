extends Control

func _process(delta):
	if Input.is_action_just_pressed("menu_pull"):
		if get_parent().get_node("tmp").UIlock:
			get_parent().get_node("tmp").UIlock = false
		else:
			get_parent().get_node("tmp").UIlock = true
		visible = !visible
