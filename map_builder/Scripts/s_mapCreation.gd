extends Control
@onready var shell = get_tree().get_root().get_node("shell")
@onready var mapWorldScene = load("res://Scenes/mapWorld.tscn")
var mapSize = 4
func set_MapSize(num):
	mapSize = num


func _on_create_map_pressed():
	if !$mapName.text.length() <= 0:
		shell.get_node("tmp").set_TmpGridSize(mapSize)
		shell.get_node("tmp").set_nameOfFile($mapName.text)
		shell.get_node("sceneChanger").changeSceneTo(shell.get_node("container"), mapWorldScene)

func _on_thirty_two_pressed():
	set_MapSize(32)


func _on_sixty_four_pressed():
	set_MapSize(64)


func _on_one_twenty_eight_pressed():
	set_MapSize(128)
