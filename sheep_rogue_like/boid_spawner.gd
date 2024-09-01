extends Node2D
@export var boid:PackedScene
var rng = RandomNumberGenerator.new()
var count = 0

# Game can only handle 220
func _ready():
	$Timer2.start()
	await $Timer2.timeout
	spawn()

func spawn():
	$Timer.start()
	await $Timer.timeout
	count += 1
	var boidInstance = boid.instantiate()
	var my_random_numberX = rng.randf_range(-10.0, 10.0)
	var my_random_numberY = rng.randf_range(-10.0, 10.0)
	var newPos = Vector2(position.x + my_random_numberX, position.y+my_random_numberY)
	boidInstance.position = newPos
	get_parent().call_deferred("add_child",boidInstance)
	if Engine.get_frames_per_second() >= 60 and count <= 5:
		spawn()
