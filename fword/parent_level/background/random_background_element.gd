extends CanvasLayer

var allBackgroundElements = []
var top_limit
var bottom_limit
var left_limit
var right_limit

func _ready():
	set_visible(true)
	get_bounds($"../TileMap")
	place_particle_generator()
	randomize()
	for each in get_children():
		if each.is_class("Sprite2D") || each.is_class("AnimatedSprite2D"):
			each.offset.y = -64
			allBackgroundElements.append(each)
	randomizePosition()


func place_particle_generator():
	$CPUParticles2D.position = Vector2(left_limit,top_limit)
	$CPUParticles2D.set_emission_rect_extents(Vector2(right_limit,2.0))
	$CPUParticles2D.set_amount(right_limit/50.0)


func get_bounds(tile_map: TileMap):
	if tile_map.has_method("get_used_rect"):
		var bounding_box = tile_map.get_used_rect()
		var scalar: Vector2 = Vector2(tile_map.tile_set.tile_size.x * tile_map.scale.x, tile_map.tile_set.tile_size.y * tile_map.scale.y)
		left_limit = bounding_box.position.x * scalar.x
		right_limit = bounding_box.end.x * scalar.x
		top_limit= bounding_box.position.y * scalar.y
		bottom_limit = bounding_box.end.y * scalar.y
		bottom_limit -= scalar.y


func randomizePosition():
	allBackgroundElements.shuffle()
	var xValuesToAvoid = []
	var order = -1
	var startCount = 2
	var count = 2
	for each in allBackgroundElements:
		each.flip_h = randi_range(0,1)
		var randomRotation = randi_range(-8, 8)
		each.set_rotation_degrees(randomRotation)
		each.z_index = order
		count -= 1
		each.position.x += randf_range(left_limit, right_limit)
		each.position.y = bottom_limit + 20
		each.position.y = randf_range(each.position.y, bottom_limit + 25)
		if count == 0:
			order -= 1
			startCount += 1
			count = startCount
