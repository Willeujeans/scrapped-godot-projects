extends Node

@onready var player_in_danger = false

func set_player_in_danger():
	$TimerTillSafe.start()
	$ChaseMusic.stream_paused = false
	player_in_danger = true

func set_player_out_danger():
	player_in_danger = false

func _process(delta):
	if $TimerTillSafe.is_stopped():
		set_player_out_danger()
	if player_in_danger:
		fade_in_chase(delta)
	else:
		fade_out_chase(delta)


func fade_in_chase(delta):
	$ChaseMusic.volume_db = lerp($ChaseMusic.volume_db , 0.0, delta)


func fade_out_chase(delta):
	$ChaseMusic.volume_db = lerp($ChaseMusic.volume_db , -5.0, delta)
	if $ChaseMusic.volume_db + -0.5 <= -5.0:
		$ChaseMusic.stream_paused = true
