extends Button
@export var scene_changer: NodePath
@export var can_be_clicked: bool = false


func _on_pressed():
	if can_be_clicked:
		get_node(scene_changer).go_next_scene()
