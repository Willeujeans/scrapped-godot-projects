extends Node2D

var can_trigger = true
var my_old_parent = null
@onready var attatchment_point = $RigidBody2D/AttatchmentPoint
var children_limbs = []
var trigger_button = ""

func set_up():
	$PinJoint2D.set_node_a(get_parent().get_path())


func activate():
	activate_children_limbs()


func activate_children_limbs():
	for each in children_limbs:
		$TriggerChildrenDelay.start()
		await $TriggerChildrenDelay.timeout
		each.activate()
