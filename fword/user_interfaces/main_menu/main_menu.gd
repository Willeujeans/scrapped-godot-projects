extends Control

func _ready():
	$Start.grab_focus()


func _on_start_pressed():
	$SceneChangeNode.go_next_scene()
