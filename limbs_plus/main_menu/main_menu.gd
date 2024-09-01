extends Control

func _ready():
	AudioServer.set_bus_volume_db(0, 0.0)
	$SceneChangeNode.next_scene = load("res://world/test_world2D.tscn")

func _on_button_pressed():
	$SceneChangeNode.go_next_scene()
