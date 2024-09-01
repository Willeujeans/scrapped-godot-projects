extends Control

@export var next_scene: PackedScene

func _on_button_start_pressed():
	get_tree().get_first_node_in_group("scene_manager").change_scene(next_scene.instantiate())
