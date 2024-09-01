extends RigidBody2D

var rng = RandomNumberGenerator.new()
func _ready():
	set_angular_velocity(rng.randf_range(-15.0, 15.0))
	set_linear_velocity(Vector2(rng.randf_range(-50.0, 50.0), rng.randf_range(-50.0, 50.0)))
