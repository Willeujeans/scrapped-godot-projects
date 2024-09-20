extends Control

@export var normal_theme: Resource
@export var flipped_theme: Resource
@export var golden_theme: Resource
@export var shine_material: Resource

var can_play = true
var is_flipped = false
var is_flipping = false

var level_scene: PackedScene
var level_name = ""
var level_time: int = -1
var level_time_flipped: int = -1
var level_star_count = 0


func set_level(scene):
	level_scene = scene
	$SceneChangeNode.next_scene = scene


func _ready():
	set_level_name()
	set_level_time()
	set_level_star_count()
	set_color_swatches()
	$SceneChangeNode.current_parent_scene = get_parent().get_parent().get_path()


func set_level_name():
	level_name = str(level_scene.get_state().get_node_name(0))
	$Control/Name.set_text("[center]" + level_name + "[/center]")


func set_level_time():
	var level_progress_times = get_tree().get_first_node_in_group("level_progress").level_times
	if level_progress_times.has(level_name):
		level_time = level_progress_times[level_name]
		$Control/Time.set_text("[center]" + format_time(level_time) + "[/center]")
	else:
		$Control/Time.set_text("[center]" + "x" + "[/center]")


func format_time(milliseconds: int) -> String:
	var total_seconds = milliseconds / 1000
	var seconds = total_seconds
	var ms = milliseconds % 1000
	return str(seconds) + "." + str(ms)[0] + str(ms)[1] + "s"


func set_level_star_count():
	if level_time <= -1:
		return
	var star_times_in_node_name = level_scene.get_state().get_node_name(2)
	var list_of_star_times = star_times_in_node_name.split("*")
	var star_string = ""
	for star_time in list_of_star_times:
		if level_time/1000 < int(star_time):
			level_star_count += 1
			star_string += "*"
	
	if star_string == "****":
		star_string = "***"
	$Control/StarCount.set_text("[wave amp=50.0]" + star_string + "[/wave]")
	if level_star_count >= 4:
		%LevelButton.set("theme_override_styles/normal", golden_theme)
		%LevelButton.set("theme_override_styles/focus", golden_theme)
		%LevelButton.material = shine_material


func set_color_swatches():
	var colors_in_node_name = level_scene.get_state().get_node_name(1)
	var list_of_colors = colors_in_node_name.split("_")
	$Control/Color1.color = list_of_colors[0]
	$Control/Color1Splat.rotation = deg_to_rad(randf_range(0,360))
	$Control/Color1Splat.position.x += randf_range(-60, 60)
	$Control/Color1Splat.modulate = list_of_colors[0]
	$Control/Color2.color = list_of_colors[1]
	$Control/Color2Splat.rotation = deg_to_rad(randf_range(0,360))
	$Control/Color2Splat.position.x += randf_range(-60, 60)
	$Control/Color2Splat.modulate = list_of_colors[1]
	$Control/Color3.color = list_of_colors[2]
	$Control/Color3Splat.rotation = deg_to_rad(randf_range(0,360))
	$Control/Color3Splat.position.x += randf_range(-60, 60)
	$Control/Color3Splat.modulate = list_of_colors[2]


func _on_button_pressed():
	$SceneChangeNode.flag = is_flipped
	$SceneChangeNode.go_next_scene()


func _process(delta):
	if %LevelButton.has_focus() and can_play:
		can_play = false
		$FipThrough.pitch_scale = randf_range(0.7, 1.1)
		$FipThrough.play()
		$Shuffle.pitch_scale = randf_range(0.7, 1.1)
		$Shuffle.play()
	if not %LevelButton.has_focus():
		can_play = true


func flip():
	if is_flipping:
		return
	$Flip.pitch_scale = randf_range(0.8, 1.2)
	$Flip.play()
	is_flipping = true
	if is_flipped:
		$AnimationPlayer.play_backwards("flip")
		$AnimationPlayer/Timer.start()
		await $AnimationPlayer/Timer.timeout
		var black = Color(0.0,0.0,0.0,1.0)
		$Control/Time.set("theme_override_colors/default_color", black)
		$Control/Name.set("theme_override_colors/default_color", black)
		%LevelButton.set("theme_override_styles/normal", normal_theme)
		%LevelButton.set("theme_override_styles/focus", normal_theme)
		is_flipped = false
		$Control/Name.set_text("[center]" + level_name + "[/center]")
	else:
		$AnimationPlayer.play("flip")
		$AnimationPlayer/Timer.start()
		await $AnimationPlayer/Timer.timeout
		var white = Color(1.0,1.0,1.0,1.0)
		$Control/Time.set("theme_override_colors/default_color", white)
		$Control/Name.set("theme_override_colors/default_color", white)
		%LevelButton.set("theme_override_styles/normal", flipped_theme)
		%LevelButton.set("theme_override_styles/focus", flipped_theme)
		is_flipped = true
		$Control/Name.set_text("[center]" + level_name.reverse() + "[/center]")


func _on_animation_player_animation_finished(anim_name):
	is_flipping = false
