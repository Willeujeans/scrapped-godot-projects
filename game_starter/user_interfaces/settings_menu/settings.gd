extends Control

func _ready():
	set_visibility_of_all_canvas_nodes(self, false)
	var video_settings = ConfigHandler.load_video_settings()
	var audio_settings = ConfigHandler.load_audio_settings()


func _process(delta):
	if Input.is_action_just_pressed("pause"):
		print("pause button pressed")
		if get_tree().paused:
			unpause()
		else:
			pause()


func set_visibility_of_all_canvas_nodes(node, visibility):
	if !node.get_children().is_empty():
		for child in node.get_children():
			if child.is_class("CanvasLayer"):
				child.set_visible(visibility)
			set_visibility_of_all_canvas_nodes(child, visibility)


func pause():
	set_visibility_of_all_canvas_nodes(self, true)
	get_tree().paused = true


func unpause():
	set_visibility_of_all_canvas_nodes(self, false)
	get_tree().paused = false
