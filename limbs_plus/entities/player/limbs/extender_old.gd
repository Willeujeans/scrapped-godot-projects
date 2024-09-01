extends CollisionShape2D

@export var max_height = 200.0
@export var speed = 10.0
var current_added = 0.0
var starting_x = 0.0
var is_active = false
var is_extending = true

func activate():
	if !is_active:
		is_active = true

func _process(delta):
	if is_active:
		if is_extending:
			extend()
		else:
			retract()
	

func extend():
	get_parent().lock_rotation = true
	$AnimatedSprite2D.play("open")
	var direction = ($RayCast2D.global_position - to_global($RayCast2D.target_position)).normalized()
	shape.size -= direction * speed
	position += direction * speed
	current_added += speed
	if current_added > max_height:
		is_active = false
		get_parent().lock_rotation = false
		$Timer.start()
		await $Timer.timeout
		is_active = true
		is_extending = false


func retract():
	get_parent().lock_rotation = true
	$AnimatedSprite2D.play("default")
	shape.size.x += speed
	position.x -= speed
	$ColorRect.position.x += speed
	$ColorRect.size.x -= speed
	current_added -= speed
	if current_added <= 0.0:
		is_active = false
		
		get_parent().lock_rotation = false
		is_extending = true
