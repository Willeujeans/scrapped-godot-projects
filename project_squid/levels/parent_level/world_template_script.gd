extends Node2D

@export var flipped = false
@export var color_pal: Array[Vector3] = []
@export var transition_scene: PackedScene
@onready var can_restart = true
var escape_time_bank = 1.0


func _ready():
	if flipped:
		$TileMap.set_rotation_degrees(180)
		var rectangle = $TileMap.get_used_rect()
		var adjustment = Vector2($TileMap.scale.x * $TileMap.tile_set.tile_size.x * rectangle.size.x - rectangle.position.x, -1 * $TileMap.scale.y * $TileMap.tile_set.tile_size.y * (rectangle.size.y - rectangle.position.y))
		$TileMap.position = Vector2(adjustment.x, adjustment.y/2)
	$Squid.get_node("PlayerCamera").set_limits()
	$SceneChangeNode.next_scene = load("res://menus/level_select/level_selection_carousell.tscn")
	var color_string = get_children()[0].name
	var colors_string_as_list = color_string.split("_")
	var color_list = []
	for each in colors_string_as_list:
		color_list.append(Color(each))
	$Squid.color_list = color_list
	$TileMap.fill_background_with_black()
	$TileMap.add_black_tiles()
	$TileMap.replace_tiles_with_objects()
	$Squid.global_position = $TileMap/SpawnPoint.global_position


func _process(delta):
	if Input.is_action_just_pressed("reset") and $TimerReset.is_stopped() and can_restart:
		restart()
	if Input.is_action_pressed("escape"):
		escape_time_bank -= 1.0 * delta
		$UI/Control/HoldForLevelSelect.visible = true
	if escape_time_bank <= 0:
			$SceneChangeNode.go_next_scene()
	if Input.is_action_just_released("escape") and escape_time_bank > 0:
		escape_time_bank = 1.0
		$UI/Control/HoldForLevelSelect.visible = false


func restart():
	can_restart = false
	var transition = transition_scene.instantiate()
	transition.play_speed = 2.0
	transition.connect("total_eclipse", func(): finish_restart())
	get_parent().add_child(transition)


func finish_restart():
	var parent_node = get_parent()
	parent_node.remove_child(self)
	var scene = load(self.get_scene_file_path()).instantiate()
	scene.flipped = flipped
	parent_node.call_deferred("add_child", scene)
	queue_free()


func go_back_to_level_select():
	$SceneChangeNode/TillNextScene.start()
	await $SceneChangeNode/TillNextScene.timeout
	$SceneChangeNode.go_next_scene()
