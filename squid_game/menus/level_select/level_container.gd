extends Control
var can_play = true

func set_level(level_scene):
	$SceneChangeNode.next_scene = level_scene


func _on_button_pressed():
	$SceneChangeNode.go_next_scene()


func _process(delta):
	if $Button.has_focus() and can_play:
		can_play = false
		$FipThrough.pitch_scale = randf_range(0.7, 1.1)
		$FipThrough.play()
		$Shuffle.pitch_scale = randf_range(0.7, 1.1)
		$Shuffle.play()
	if not $Button.has_focus():
		can_play = true
