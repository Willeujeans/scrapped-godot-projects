extends TileMap

@onready var area = $Area2D

func _ready():
	var layer = 0
	var used_cells = get_used_cells(layer)
	
	for cell in used_cells:
		var data = get_cell_tile_data(layer, cell)
		var points = data.get_collision_polygon_points(0, layer)
		var collision_shape = CollisionPolygon2D.new()
		collision_shape.polygon = points
		collision_shape.position = to_global(map_to_local(cell))
		area.add_child(collision_shape)
