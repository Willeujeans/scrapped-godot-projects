extends RigidBody2D
var is_grabbed = false
var is_attached = false
@onready var parent_body = get_tree().get_first_node_in_group("player")
var can_scream = true

func _process(delta):
	if linear_velocity.length() >= 300.0:
		if can_scream:
			reset_scream()
			$Scream.pitch_scale = randf_range(1.1, 1.4)
			$Scream.play()
		$AnimatedSprite2D.play("thrown")
	else:
		$AnimatedSprite2D.play("default")

func reset_scream():
	can_scream = false
	$ScreamTimer.start()
	await $ScreamTimer.timeout
	can_scream = true
	
func _integrate_forces(state):
	if is_attached and !$"../..".children_limbs.is_empty():
		set_angular_velocity((get_angle_to(parent_body.global_position)) * -((get_angle_to(parent_body.global_position)) -3.14) * 5)
