extends Node2D

@onready var default_length = $DampedSpringJoint2D.get_length()
@onready var default_rest_length = $DampedSpringJoint2D.get_rest_length()
var stored_position
var is_active = false

func set_up():
	$DampedSpringJoint2D.set_node_a($"..".get_parent().get_path())



func activate():
	$RigidBody2D/CollisionShape2D.set_deferred("disabled", false)
	$DampedSpringJoint2D.set_node_b($RigidBody2D.get_path())
	is_active = true
	stored_position = $RigidBody2D.global_position
	$DampedSpringJoint2D.set_length(0.0)
	$DampedSpringJoint2D.set_rest_length(0.0)


func deactivate():
	is_active = false
	get_parent().can_activate = true


func _physics_process(delta):
	if $RigidBody2D.global_position.distance_to($"..".get_parent().global_position) <= 100.0:
		deactivate()
	if is_active:
		$RigidBody2D.global_position = stored_position
