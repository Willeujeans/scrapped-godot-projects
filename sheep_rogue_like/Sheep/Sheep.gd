extends CharacterBody2D
const SPEED = 25.0
@export var marker:PackedScene


var nearby_boids = []
var direction = Vector2.ZERO
var targetPosition = Vector2.ZERO
var rng = RandomNumberGenerator.new()

func _physics_process(delta):
	boids()
	checkCollision()
	velocity = velocity.normalized() * SPEED
	move()
	rotation = lerp_angle(rotation, velocity.angle_to_point(Vector2.ZERO),0.4)
	animation_handling(delta)
	targetPosition = calculate_centroid()
	direction = (targetPosition - position).normalized()
	velocity = direction * SPEED
	move_and_slide()

func boids():
	if !nearby_boids.is_empty():
		var numberOfBoids = nearby_boids.size()
		var averageVelocity := Vector2.ZERO
		var averagePosition := Vector2.ZERO
		var steerAway := Vector2.ZERO
		for boid in nearby_boids:
			averageVelocity += boid.velocity
			averagePosition += boid.position
		
		averageVelocity /= numberOfBoids
		velocity += (averageVelocity-velocity)/2
		
		averagePosition /= numberOfBoids
		velocity += (averagePosition-position)
		
func checkCollision():
	pass

func move():
	move_and_slide()


func spawn_marker(pos):
	print(pos)
	var markerSpawn = marker.instantiate()
	markerSpawn.position = pos
	get_parent().call_deferred("add_child",markerSpawn)


func calculate_centroid()-> Vector2:
	if nearby_boids.is_empty():
		return Vector2.ZERO
	var sumX = 0.0
	var sumY = 0.0
	for boid in nearby_boids:
		sumX += boid.position.x
		sumY += boid.position.y
	sumX /= nearby_boids.size()
	sumY /= nearby_boids.size()
	var average_position = Vector2(sumX,sumY)
	spawn_marker(average_position)
	return average_position


func _on_vision_area_body_entered(body):
	if body.is_in_group("boid") and body != self:
		nearby_boids.append(body)


func _on_vision_area_body_exited(body):
	if body.is_in_group("boid") and body != self:
		nearby_boids.remove_at(nearby_boids.find(body,0))
		print(self, " ", nearby_boids)


func animation_handling(delta):
	print(rotation)
