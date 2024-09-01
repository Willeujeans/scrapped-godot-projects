extends StaticBody2D

func _ready():
	var player_camera = get_tree().get_first_node_in_group("player_camera")
	player_camera.screen_shake(10.0, 4.0)
	shapeAnimation()
	play_impact_sounds()
	$CPUParticles2D.emitting = true


func shapeAnimation():
	$AnimationOtherTimer.start()
	var original_scale = $Sprite2D.scale.x
	$Sprite2D.scale.x = original_scale + 0.4
	await $AnimationOtherTimer.timeout
	$AnimationTimer.start()
	$Sprite2D.scale.x = original_scale - 0.4
	await $AnimationTimer.timeout
	$AnimationTimer.start()
	$Sprite2D.scale.x = original_scale
	await $AnimationTimer.timeout


func play_impact_sounds():
	$AudioEmpty/ThudAudio.play()
	$AudioEmpty/BitExplosionAudio.play()
