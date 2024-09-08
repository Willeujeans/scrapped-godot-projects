extends TileMap
@export var current_level = 0
var all_paintable_tiles = []
var total_painted = 0
@onready var level_select = load("res://level_select.tscn")
var can_change_scene = true
var world_time = 0.0
var world_timer_active = false
var start_time = 0.0
var end_time
@onready var level_completed = false

func _ready():
	replace_tiles_with_objects()


func replace_tiles_with_objects(layer: int = 0):
	for cell_position in get_used_cells(layer):
		var tile_object = get_cell_tile_data(layer, cell_position)
		var replacement_object_scene = tile_object.get_custom_data("replacement")
		if replacement_object_scene:
			var replacement_object = replacement_object_scene.instantiate()
			replacement_object.position = to_global(map_to_local(cell_position))
			get_parent().call_deferred("add_child", replacement_object)
	$"../Timer2".start()
	await $"../Timer2".timeout
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
	$"../CanvasLayer/Control/RichTextLabel".set_text(formatted_text)
	if percentage >= 100 and can_change_scene:
		level_completed = true
		world_timer_active = false
		can_change_scene = false
		end_time = Time.get_ticks_msec()
		world_time = end_time - start_time
		get_tree().get_first_node_in_group("level_progress").level_times[current_level] = world_time
		$"../Timer".start()
		await $"../Timer".timeout
		$"../SceneChangeNode".next_scene = level_select
		$"../SceneChangeNode".go_next_scene()

var escape_time_bank = 1.0
func _process(delta):
	if Input.is_action_pressed("escape"):
		escape_time_bank -= 1.0 * delta
		$"../CanvasLayer/Control/HoldForLevelSelect".visible = true
		if escape_time_bank <= 0:
			$"../SceneChangeNode".next_scene = level_select
			$"../SceneChangeNode".go_next_scene()
	if Input.is_action_just_released("escape") and escape_time_bank > 0:
		escape_time_bank = 1.0
		$"../CanvasLayer/Control/HoldForLevelSelect".visible = false
	if world_timer_active:
		var current_time = (Time.get_ticks_msec() - start_time) * 0.001
		var current_time_string = "%.1f" % current_time
		$"../CanvasLayer/Control/TimeText".text = "[wave]" + current_time_string + "[/wave]"
