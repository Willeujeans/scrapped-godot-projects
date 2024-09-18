extends Control
var can_play = true
var is_flipped = false
var is_flipping = false
@export var list_of_stars = []
@export var list_of_colors = []
@export var normal_theme: Resource
@export var flipped_theme: Resource
@export var golden_theme: Resource


func _ready():
	set_color_swatches()


func set_level(level_scene):
	$SceneChangeNode.next_scene = level_scene


func _on_button_pressed():
	$SceneChangeNode.flag = is_flipped
	$SceneChangeNode.go_next_scene()


func _process(delta):
	if $Control/Button.has_focus() and can_play:
		can_play = false
		$FipThrough.pitch_scale = randf_range(0.7, 1.1)
		$FipThrough.play()
		$Shuffle.pitch_scale = randf_range(0.7, 1.1)
		$Shuffle.play()
	if not $Control/Button.has_focus():
		can_play = true


func set_color_swatches():
	$Control/Color1.color = list_of_colors[0]
	$Control/Color2.color = list_of_colors[1]
	$Control/Color3.color = list_of_colors[2]


func flip():
	if is_flipping:
		return
	is_flipping = true
	if is_flipped:
		$AnimationPlayer.play_backwards("flip")
		$AnimationPlayer/Timer.start()
		await $AnimationPlayer/Timer.timeout
		var black = Color(0.0,0.0,0.0,1.0)
		$Control/Time.set("theme_override_colors/default_color", black)
		$Control/Name.set("theme_override_colors/default_color", black)
		$Control/Button.set("theme_override_styles/normal", normal_theme)
		$Control/Button.set("theme_override_styles/focus", normal_theme)
		is_flipped = false
	else:
		$AnimationPlayer.play("flip")
		$AnimationPlayer/Timer.start()
		await $AnimationPlayer/Timer.timeout
		var white = Color(1.0,1.0,1.0,1.0)
		$Control/Time.set("theme_override_colors/default_color", white)
		$Control/Name.set("theme_override_colors/default_color", white)
		$Control/Button.set("theme_override_styles/normal", flipped_theme)
		$Control/Button.set("theme_override_styles/focus", flipped_theme)
		is_flipped = true


func _on_animation_player_animation_finished(anim_name):
	is_flipping = false
