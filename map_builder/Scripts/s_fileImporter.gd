extends Node
var saveDocumentPath = "/Users/willschmitz/Documents/Code/mapIdea/SavedData"
@onready var blockScene = load("res://Scenes/block.tscn")
@onready var shell = get_tree().get_root().get_node("shell")
#Takes in a run length encoded string
#Converts it to an array of Terrain types
#populates a 3d array filled with blocks with those terrain types
func createMatrixFromImport(filePath):
	print("IMPORT MATRIX GENERATING...")
	var mapString = $fileReader.textFromFile(filePath)
	var mapArrayData = RLEtoArray(mapString)
	shell.get_node("tmp").set_TmpGridSize(mapArrayData.get("size"))
	print("mapSize gotten: ",mapArrayData.get("size"))
	var populatedMatrix = populateMatrix(mapArrayData.get("data"), mapArrayData.get("size"))
	return populatedMatrix


func RLEtoArray(mapString):
	print(">RLE to array...")
	var splitMap = mapString.split(" ")
	var importedGridSize = splitMap[0]
	var data = splitMap[1]
	var count = ""
	var currentTerrain = "a"
	var arrayOfBlocks = []
	for letter in data:
		if $numberChecker.check(letter):
			count += letter
		else:
			currentTerrain = letter
			for n in int(count):
				arrayOfBlocks.append(currentTerrain)
			count = ""
	var dataArray = {}
	dataArray["size"] = int(importedGridSize)
	dataArray["data"] = arrayOfBlocks
	return dataArray

func populateMatrix(in_array, size):
	print(">import matrix populating...")
	var matrix = $threeDArray.create(size)
	var index = Vector3(0,0,0)
	for n in in_array:
		if n != "a":
			var newBlock = blockScene.instantiate()
			newBlock.set_TerrainType(n)
			newBlock.mapLocation = Vector3(index.x, index.y, index.z)
			matrix[index.x][index.y][index.z] = newBlock
		else:
			matrix[index.x][index.y][index.z] = null
		index.x += 1
		if index.x >= size:
			index.x = 0
			index.z += 1
		if index.z >= size:
			index.z = 0
			index.y += 1
		if index.y >= size:
			print("DONE")
	return matrix
