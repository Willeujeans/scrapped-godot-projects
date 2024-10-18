extends Control

@export var normal_theme: Resource
@export var flipped_theme: Resource
@export var golden_theme: Resource
@export var shine_material: Resource

var can_play = true

var level_scene: PackedScene
var level_name = ""
var level_time: int = -1
var level_time_flipped: int = -1
var level_star_count_flipped = 0
var level_star_count = 0


func set_level(scene):
	level_scene = scene
	$SceneChangeNode.next_scene = scene


func _ready():
	set_level_name()
	set_level_star_count()
	
	populate_name_text(level_name)
	populate_star_text(level_star_count)
	
	$SceneChangeNode.current_parent_scene = get_parent().get_parent().get_path()


func set_level_name():
	level_name = str(level_scene.get_state().get_node_name(0))


func populate_name_text(text_name):
	$Control/Name.set_text("[center]" + text_name + "[/center]")


func set_level_star_count():
	var star_times_in_node_name = level_scene.get_state().get_node_name(2)
	var list_of_star_times = star_times_in_node_name.split("*")
	for star_time in list_of_star_times:
		if level_time/1000 < int(star_time) and level_time != -1:
			level_star_count += 1
		if level_time_flipped/1000 < int(star_time) and level_time_flipped != -1:
			level_star_count_flipped += 1


func populate_star_text(star_amount):
	var star_string = ""
	for each in star_amount:
		star_string += "*"
	if star_string == "****":
		star_string = "***"
	$Control/StarCount.set_text("[wave amp=50.0]" + star_string + "[/wave]")
	if level_star_count >= 4:
		%LevelButton.set("theme_override_styles/normal", golden_theme)
		%LevelButton.set("theme_override_styles/focus", golden_theme)
		%LevelButton.material = shine_material


func _process(delta):
	if %LevelButton.has_focus() and can_play:
		can_play = false
		$FipThrough.pitch_scale = randf_range(0.7, 1.1)
		$FipThrough.play()
	if not %LevelButton.has_focus():
		can_play = true

