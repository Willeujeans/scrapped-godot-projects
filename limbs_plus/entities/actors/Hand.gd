extends RigidBody2D

@onready var grabber = get_parent()
var is_grabbing = false
var is_extending = false
var speed = 90000.0


func _ready():
	apply_central_force(speed * (to_global($RayCast2D.target_position) - to_global($RayCast2D.position)).normalized())


func _process(delta):
	if global_position.x > grabber.global_position.x:
		$AnimatedSprite2D.scale.x = 6
	else:
		$AnimatedSprite2D.scale.x = -6
	$AnimatedSprite2D.rotation = global_position.angle_to(grabber.global_position)
	if is_extending:
		for each in $Area2D.get_overlapping_bodies():
			if each != grabber.get_parent():
				is_grabbing = true
	if is_grabbing:
		pull_self_towards_item(delta)


func pull_self_towards_item(delta):
	freeze = true
	print("pulling")
	is_extending = false
	var direction = (global_position - grabber.global_position).normalized()
	var force = 5000.0
	grabber.get_parent().constant_force = direction * force
	if global_position.distance_to(grabber.get_parent().global_position) <= 150.0:
		grabber.deactivate()
