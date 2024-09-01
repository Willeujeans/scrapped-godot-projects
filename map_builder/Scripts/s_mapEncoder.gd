extends Node

func encodeMap(in_matrix, in_mapSize):
	var mapMatrix = in_matrix
	var mapDimensions = in_mapSize
	
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
