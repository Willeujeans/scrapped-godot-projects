extends Node

func create(gridSize):
	var array = []
	array.resize(gridSize)    # X-dimension
	for x in gridSize:    # this method should be faster than range since it uses a real iterator iirc
		array[x] = []
		array[x].resize(gridSize)    # Y-dimension
		for y in gridSize:
			array[x][y] = []
			array[x][y].resize(gridSize)    # Z-dimension
	return array
