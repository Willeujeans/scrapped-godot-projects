extends TileMap
@export var current_level = 0
@onready var level_completed = false
var all_paintable_tiles = []
var total_painted = 0
var can_change_scene = true
var world_time = 0.0
var world_timer_active = false
var start_time = 0.0
var end_time
var full_black_atlas_coordinate = Vector2(7,4)


func _ready():
	fill_background_with_black()
	add_black_tiles()
	replace_tiles_with_objects()


func fill_background_with_black(background_layer: int = 1):
	var start_x = get_used_rect().position.x
	var start_y = get_used_rect().position.y
	var ignore_these_cells = get_used_cells(0)
	for x in range(start_x, get_used_rect().size.x - abs(start_x)):
		for y in range(start_y, get_used_rect().size.y - abs(start_y)):
			var current_coordinate = Vector2(x, y)
			if get_cell_tile_data(0, current_coordinate) == null:
				set_cell(background_layer, current_coordinate, 1, full_black_atlas_coordinate, 0)


func add_black_tiles(from_layer: int = 0, to_layer: int = 1):
	for cell_position in get_used_cells(from_layer):
		var atlas_coordinates = get_cell_atlas_coords(from_layer, cell_position)
		set_cell(to_layer, cell_position, 1, atlas_coordinates, 0)


func replace_tiles_with_objects(layer: int = 0):
	for cell_position in get_used_cells(layer):
		var tile_object = get_cell_tile_data(layer, cell_position)
		var replacement_object_scene = tile_object.get_custom_data("replacement")
		if replacement_object_scene:
			var replacement_object = replacement_object_scene.instantiate()
			replacement_object.position = to_global(map_to_local(cell_position))
			get_parent().call_deferred("add_child", replacement_object)
	$UntilTilesAreReplaced.start()
	await $UntilTilesAreReplaced.timeout
	all_paintable_tiles = get_tree().get_nodes_in_group("white_tiles")


func update_paint_percent():
	if not world_timer_active and not level_completed:
		world_timer_active = true
		start_time = Time.get_ticks_msec()
	total_painted += 1
	var percentage = int(round((float(total_painted) / (all_paintable_tiles.size() * 0.98)) * 100))
	if percentage > 100:
		percentage = 100
	var percentage_remapped = remap(percentage, 0, 100, 0, 1)
	var formatted_text = "[center][tornado freq={percentage_remapped}]" + str(percentage) + "%" + "[/tornado][/center]"
	formatted_text = formatted_text.format({"percentage_remapped": str(percentage_remapped)})
	$"../UI/Control/RichTextLabel".set_text(formatted_text)
	if percentage >= 100 and can_change_scene:
		level_completed = true
		world_timer_active = false
		can_change_scene = false
		end_time = Time.get_ticks_msec()
		world_time = end_time - start_time
		get_tree().get_first_node_in_group("level_progress").level_times[current_level] = world_time
		$"../SceneChangeNode/TillNextScene".start()
		await $"../SceneChangeNode/TillNextScene".timeout
		$"../SceneChangeNode".go_next_scene()


var escape_time_bank = 2.5
func _process(delta):
	if Input.is_action_pressed("escape"):
		escape_time_bank -= 1.0 * delta
		$"../UI/Control/HoldForLevelSelect".visible = true
		if escape_time_bank <= 0:
			$"../SceneChangeNode".go_next_scene()
	if Input.is_action_just_released("escape") and escape_time_bank > 0:
		escape_time_bank = 5.0
		$"../UI/Control/HoldForLevelSelect".visible = false
	if world_timer_active:
		var current_time = (Time.get_ticks_msec() - start_time) * 0.001
		var current_time_string = "%.1f" % current_time
		$"../UI/Control/TimeText".text = "[wave]" + current_time_string + "[/wave]"
