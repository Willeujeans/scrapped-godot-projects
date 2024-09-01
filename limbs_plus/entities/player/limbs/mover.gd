extends Node2D

func set_up():
	$PinJoint2D.set_node_a($"..".get_parent().get_path())
	$PinJoint2D.set_node_b($RigidBody2D.get_path())


func activate():
	pass

