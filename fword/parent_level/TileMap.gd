extends TileMap


# Called when the node enters the scene tree for the first time.
func _ready():
	replace_tiles_with_objects()

func replace_tiles_with_objects(layer: int = 0):
	for cell_position in get_used_cells(layer):
		var tile_object = get_cell_tile_data(layer, cell_position)
		var replacement_object_scene = tile_object.get_custom_data("replacement")
		if replacement_object_scene:
			erase_cell(layer, cell_position)
			var replacement_object = replacement_object_scene.instantiate()
			replacement_object.position = to_global(map_to_local(cell_position))
			get_parent().call_deferred("add_child", replacement_object)
