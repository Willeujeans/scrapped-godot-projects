extends RigidBody2D
var has_played = false
var rng = RandomNumberGenerator.new()

func _ready():
	$Timer.start()
	
func _on_body_shape_entered(body_rid, body, body_shape_index, local_shape_index):
	playThatSound(body)

func _on_body_entered(body):
	playThatSound(body)
			
func playThatSound(body):
	if !body.is_in_group("deadSquare") and !body.is_in_group("swords"):
		if !has_played and !$Timer.is_stopped():
			has_played = true
			$AudioStreamPlayer.pitch_scale += rng.randf_range(0.0, 0.5)
			$AudioStreamPlayer.play()
