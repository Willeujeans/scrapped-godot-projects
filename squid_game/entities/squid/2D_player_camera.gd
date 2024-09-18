extends Camera2D

@export var smoothing = 5.0
@export var stops_at_ceiling: bool = true


func _ready():
	set_position_smoothing_speed(smoothing)
	set_limits()


func set_limits():
	var tile_map_node = self
	var tile_map_array: Array = []
	while(tile_map_array.is_empty() and get_parent()):
		tile_map_node = tile_map_node.get_parent()
		findByClass(tile_map_node, "TileMap", tile_map_array)
	var tile_map = tile_map_array[0]
	if tile_map.has_method("get_used_rect"):
		var bounding_box = tile_map.get_used_rect()
		var scalar: Vector2 = Vector2(tile_map.tile_set.tile_size.x * tile_map.scale.x, tile_map.tile_set.tile_size.y * tile_map.scale.y)
		limit_left = bounding_box.position.x * scalar.x
		limit_right = bounding_box.end.x * scalar.x
		if stops_at_ceiling:
			limit_top = bounding_box.position.y * scalar.y
		limit_bottom = bounding_box.end.y * scalar.y

func findByClass(node: Node, className : String, result : Array) -> void:
	if !node:
		return
	if node.is_class(className):
		result.push_back(node)
	for child in node.get_children():
		findByClass(child, className, result)
