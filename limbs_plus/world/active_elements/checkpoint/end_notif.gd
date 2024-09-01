extends CanvasLayer


func go_back_hone():
	get_tree().get_first_node_in_group("scene_change_to_menu").go_next_scene()
