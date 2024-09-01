extends Button

@export var scene_to_change_to: PackedScene

func _on_pressed():
	get_tree().get_first_node_in_group("scene_manager").change_scene(scene_to_change_to.instantiate())
