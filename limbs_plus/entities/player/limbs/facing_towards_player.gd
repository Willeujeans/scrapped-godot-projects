extends RigidBody2D
@onready var parent_body = get_tree().get_first_node_in_group("player")


func _integrate_forces(state):
	set_angular_velocity((get_angle_to(parent_body.global_position)) * -((get_angle_to(parent_body.global_position)) -3.14) * 5)
