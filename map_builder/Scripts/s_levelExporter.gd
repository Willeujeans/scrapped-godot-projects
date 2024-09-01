extends Node
var saveDocumentPath = "/Users/willschmitz/Documents/Code/mapIdea/SavedData"

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_save_button_pressed():
	var mapString = encodeMap()
	write_file(saveDocumentPath + "/save_game.md", mapString)

static func write_file(file_name, string):
	var file = FileAccess.open(file_name, FileAccess.WRITE)
	file.store_string(string)
	file.close()


func encodeMap():
	var map = get_tree().current_scene.get_node("map")
	var mapMatrix = map.matrixArray
	var mapDimensions = map.gridSize
	
	var encodedString = str(mapDimensions)
	encodedString += " "
	var lastTerrain = mapMatrix[0][0][0].terrainType
	var count = 0
	for y in mapDimensions:
		for z in mapDimensions:
			for x in mapDimensions:
				#NULL CASE
				if mapMatrix[x][y][z] == null:
					if lastTerrain == "a":
						count += 1
					else:
						encodedString = addToEncodeString(encodedString, count, lastTerrain)
						count = 1
					lastTerrain = "a"
				#NON NULL CASE
				if mapMatrix[x][y][z] != null:
					if lastTerrain == mapMatrix[x][y][z].terrainType:
						count += 1
					else:
						encodedString = addToEncodeString(encodedString, count, lastTerrain)
						count = 1
					lastTerrain = mapMatrix[x][y][z].terrainType
					
	encodedString = addToEncodeString(encodedString, count, lastTerrain)
	return encodedString

func addToEncodeString(encodedString, count, addition):
	encodedString += str(count) 
	encodedString += addition
	return encodedString
