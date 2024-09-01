extends RigidBody2D
var index = 0


func _on_body_entered(body):
	$Clink.pitch_scale = randf_range(0.7, 1.4)
	$Clink.play()
