extends Node
func exportFile(in_fileName, in_matrix, in_size):
	var mapString = $mapEncoder.encodeMap(in_matrix, in_size)
	var path = get_parent().get_node("tmp").saveFilePath + in_fileName
	write_file(path, mapString)

static func write_file(file_name, string):
	var file = FileAccess.open(file_name, FileAccess.WRITE)
	file.store_string(string)
	file.close()
