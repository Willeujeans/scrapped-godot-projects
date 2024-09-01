extends TileMap
var all_paintable_tiles = []


func _ready():
	replace_tiles_with_objects()


func replace_tiles_with_objects(layer: int = 1):
	for cell_position in get_used_cells(layer):
		var tile_object = get_cell_tile_data(layer, cell_position)
		var replacement_object_scene = tile_object.get_custom_data("replacement")
		if replacement_object_scene:
			var replacement_object = replacement_object_scene.instantiate()
			replacement_object.position = to_global(map_to_local(cell_position))
			get_parent().call_deferred("add_child", replacement_object)
			all_paintable_tiles.append(replacement_object)


func update_paint_percent():
	var white_tile_total = 0
	for tile in all_paintable_tiles:
		if not tile.is_painted:
			white_tile_total += 1
	var percentage = int(round((float(white_tile_total) / all_paintable_tiles.size()) * 100))
	var reverse_percentage = 100 - percentage
	$"../CanvasLayer/Control/RichTextLabel".set_text("[center]" + str(reverse_percentage) + "%" + "[/center]")
	if percentage == 100:
		$"../Timer".start()
		await $"../Timer".timeout
		$"../SceneChangeNode".next_scene = "res://level_select.tscn"
		$"../SceneChangeNode".go_next_scene()
