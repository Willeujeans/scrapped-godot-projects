extends CheckButton
var screen_shake_active: bool = true


func _ready():
	var video_settings = ConfigHandler.load_video_settings()
	var loaded_value = video_settings.get("screen_shake")
	screen_shake_active = loaded_value
	self.set_pressed(screen_shake_active)


func _on_pressed():
	if screen_shake_active:
		screen_shake_active = false
		ConfigHandler.save_video_setting("screen_shake", screen_shake_active)
	else:
		screen_shake_active = true
		ConfigHandler.save_video_setting("screen_shake", screen_shake_active)
	if get_tree().get_first_node_in_group("player_camera"):
		get_tree().get_first_node_in_group("player_camera").screen_shake_active = screen_shake_active
