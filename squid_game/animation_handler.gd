extends Node

signal animate(current_frame)

var my_current_frame = 0

func _ready():
	play_frame()


func play_frame():
	if my_current_frame == 0:
		my_current_frame = 1
		animate.emit(1)
	else:
		my_current_frame = 0
		animate.emit(0)
	$Timer.start()
	await $Timer.timeout
	play_frame()
