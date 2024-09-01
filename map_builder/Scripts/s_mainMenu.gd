extends Node3D

func _ready():
	var saveDocumentPath = "/Users/willschmitz/Documents/Code/mapIdea/SavedData"
	#saveDocumentPath = "D:/godotProjects/mapIdea/SavedData"
	loadAllSavedFiles(saveDocumentPath)

func loadAllSavedFiles(folder):
	var shell = get_tree().get_root().get_node("shell")
	var filesArray = shell.get_node("directoryScanner").list_files_in_directory(folder)
	for file in filesArray:
		$fileVisualContainer.createFileVisual(file)

func _on_create_new_map_button_pressed():
	var mapCreationScene = load("res://Scenes/mapCreation.tscn")
	get_parent().get_parent().get_node("sceneChanger").changeSceneTo(get_parent(), mapCreationScene)
