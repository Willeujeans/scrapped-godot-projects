extends Control

func _ready():
	$VBoxContainer/Button.grab_focus()


func _on_button_pressed():
	$SceneChangeNode.go_next_scene()
