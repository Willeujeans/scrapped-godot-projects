extends Area2D

@onready var rayFolder := $rayFolder.get_children()
@export var speed := 5.0
@export var avoidance := 55
@export var footsteps : PackedScene

var nearbyBoids := []
var velocity := Vector2.ZERO
var screensize : Vector2

func place_footsteps():
	$FootStepTimer.start()
	await $FootStepTimer.timeout
	if velocity != Vector2.ZERO:
		var footstepSpawn = footsteps.instantiate()
		footstepSpawn.position = position
		footstepSpawn.rotation = rotation
		get_parent().call_deferred("add_child",footstepSpawn)
	place_footsteps()

func _ready() -> void:
	screensize = get_viewport_rect().size
	randomize()
	place_footsteps()

func _physics_process(delta: float) -> void:
	handle_anims()
	boids()
	checkCollision()
	velocity = velocity.normalized() * speed
	move()
	rotation = lerp_angle(rotation, velocity.angle_to_point(Vector2.ZERO), 0.05)

func boids() -> void:
	if !nearbyBoids.is_empty():
		var numOfBoids := nearbyBoids.size()
		var avgvelocity := Vector2.ZERO
		var avgPos := Vector2.ZERO
		var steerAway := Vector2.ZERO
		for boid in nearbyBoids:
			avgvelocity += boid.velocity
			avgPos += boid.position
			steerAway -= (boid.global_position - global_position) * (avoidance/( global_position- boid.global_position).length())

		# Alignment
		avgvelocity /= numOfBoids
		velocity += (avgvelocity - velocity)/2

		# Cohesion
		avgPos /= numOfBoids
		velocity += (avgPos - position)

		# Serperation
		steerAway /= numOfBoids
		velocity += (steerAway)

func checkCollision() -> void:
	for ray in rayFolder:
		if ray.is_colliding():
			if ray.get_collider().is_in_group("blocks"):
				var magi = (100/(ray.get_collision_point() - global_position).length_squared())
				velocity -= (ray.target_position.rotated(rotation) * magi)
		pass

func move() -> void:
	global_position += velocity
	if global_position.x < 0:
		global_position.x = screensize.x 
	if global_position.x > screensize.x:
		global_position.x = 0
	if global_position.y < 0:
		global_position.y = screensize.y 
	if global_position.y > screensize.y:
		global_position.y = 0

func _on_vision_area_entered(area: Area2D) -> void:
	if area != self and area.is_in_group("boid"):
		nearbyBoids.append(area)
		
func _on_vision_area_exited(area: Area2D) -> void:
	if area and area.is_in_group("boid"):
		nearbyBoids.erase(area)

func _on_boid_body_entered(body: Node) -> void:
	if body:
		print("hit smth :(")

func handle_anims():
	if velocity.x > velocity.y:
		if cos(rotation) > 0:
			$AnimatedSprite2D.play("left")
		if cos(rotation) < 0:
			$AnimatedSprite2D.play("right")
	else:
		if sin(rotation) > 0:
			$AnimatedSprite2D.play("up")
		if sin(rotation) < 0:
			$AnimatedSprite2D.play("down")

