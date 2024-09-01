extends Camera2D
@export var random_shake_strength: float = 4.0
@export var shake_decay_rate: float = 5.0
@export var stops_at_ceiling: bool = true
@onready var camera: Camera2D = self
@onready var rand = RandomNumberGenerator.new()
var shake_strength: float = 0.0
var screen_shake_active: bool = true

func _ready():
	$TimeTillSmooth.start()
	var video_settings = ConfigHandler.load_video_settings()
	var loaded_value = video_settings.get("screen_shake")
	screen_shake_active = loaded_value
	rand.randomize()
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
		await $TimeTillSmooth.timeout
		position_smoothing_enabled = true


func findByClass(node: Node, className : String, result : Array) -> void:
	if !node:
		return
	if node.is_class(className):
		result.push_back(node)
	for child in node.get_children():
		findByClass(child, className, result)


func screen_shake(strength: float, decay: float):
	if screen_shake_active:
		random_shake_strength = strength
		shake_decay_rate = decay
		apply_shake()

func _process(delta: float) -> void:
	shake_strength = lerp(shake_strength, 0.0, shake_decay_rate * delta)
	camera.offset = get_random_offset()


func apply_shake() -> void:
	shake_strength = random_shake_strength


func get_random_offset() -> Vector2:
	return Vector2(
		rand.randf_range(-shake_strength, shake_strength),
		rand.randf_range(-shake_strength, shake_strength)
	)
