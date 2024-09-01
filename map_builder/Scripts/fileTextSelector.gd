extends Control
var filePath = ""
var fileName = ""

func set_filePath(in_filePath):
	filePath = in_filePath

func set_fileName(name):
	fileName = name
	
func _on_button_pressed():
	var shell = get_tree().get_root().get_node("shell")
	shell.get_node("tmp").set_importedFilePath(filePath)
	shell.get_node("tmp").nameOfFile = fileName
	var mapWorldScene = load("res://Scenes/mapWorld.tscn")
	shell.get_node("sceneChanger").changeSceneTo(shell.get_node("container"),mapWorldScene)
