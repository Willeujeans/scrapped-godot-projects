extends VBoxContainer
@export var bus_name: String = "Master"
@onready var bus_id: int = AudioServer.get_bus_index(bus_name)

func _ready():
	$Label.set_text(bus_name)
	var audio_settings = ConfigHandler.load_audio_settings()
	var loaded_value = audio_settings.get(bus_name + "_volume")
	if !loaded_value:
		return
	change_audio(loaded_value)
	$Slider.value = loaded_value


func _on_h_slider_value_changed(value):
	change_audio(value)


func change_audio(value):
	AudioServer.set_bus_volume_db(bus_id, linear_to_db(value))
	AudioServer.set_bus_mute(bus_id, value < 0.05)
	ConfigHandler.save_audio_settings(bus_name + "_volume", value)
