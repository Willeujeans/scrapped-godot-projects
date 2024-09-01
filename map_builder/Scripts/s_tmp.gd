extends Node
var tmpGridSize = 4
var nameOfFile = ""
var saveFilePath = "/Users/willschmitz/Documents/Code/mapIdea/SavedData/"
var importedFilePath = ""
var UIlock = false

func set_importedFilePath(in_filePath):
	importedFilePath = in_filePath
	
func set_nameOfFile(in_name):
	nameOfFile = in_name + ".md"
	
func set_TmpGridSize(size):
	print("tmpGridSize:", size)
	tmpGridSize = size
