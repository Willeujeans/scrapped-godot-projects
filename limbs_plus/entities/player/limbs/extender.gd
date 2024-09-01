extends Node2D

var active = false


func set_up():
	$PinJoint2D.set_node_a(get_parent().get_parent().get_path())
	$PinJoint2D.set_node_b($RigidBody2D.get_path())
	print("activation set up")


func activate():
	print("activation node activated")
	active = true
	var direction =  ($PinJoint2D/EndPoint.global_position - $PinJoint2D.global_position).normalized()
	var magnitude = 100000.0
	$RigidBody2D.active = true
	$RigidBody2D.apply_central_force(direction * magnitude)
	print($RigidBody2D.linear_velocity)
	$"..".can_activate = true
	
