extends Control
@onready var fileButton = load("res://Scenes/fileTextSelector.tscn")
@onready var shell = get_tree().get_root().get_node("shell")
var spacing = 0
func createFileVisual(file):
	print("creating visual for: " , file)
	var fileButtonNode = fileButton.instantiate()
	fileButtonNode.set_filePath(shell.get_node("tmp").saveFilePath + file)
	fileButtonNode.set_fileName(file)
	fileButtonNode.position.y = spacing
	fileButtonNode.get_node("Button").text = file
	add_child(fileButtonNode)
	spacing += fileButtonNode.get_node("Button").size.y + 10
