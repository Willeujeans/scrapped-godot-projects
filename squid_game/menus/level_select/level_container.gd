extends Control


func set_level(level_scene):
	$SceneChangeNode.next_scene = level_scene


func _on_button_pressed():
	$SceneChangeNode.go_next_scene()
