extends Node2D
@export var power = 1.0
@export var foot_scene: PackedScene
@onready var default_rest_length = $DampedSpringJoint2D.get_rest_length()
@onready var default_length = $DampedSpringJoint2D.get_length()
var total_width = 100.0

func set_up():
	$GrooveJoint2D.set_node_a($"..".get_parent().get_path())
	$GrooveJoint2D.set_node_b($RigidBody2D.get_path())
	$DampedSpringJoint2D.set_node_a($"..".get_parent().get_path())
	$DampedSpringJoint2D.set_node_b($RigidBody2D.get_path())


func activate():
	$DampedSpringJoint2D.set_rest_length(90.0 * power)
	$DampedSpringJoint2D.set_length(90.0)
	$TimeTillRetraction.start()
	await $TimeTillRetraction.timeout
	deactivate()

func deactivate():
	$DampedSpringJoint2D.set_rest_length(default_rest_length)
	$DampedSpringJoint2D.set_length(default_length)
	$TimeTillRetraction.start()
	await $TimeTillRetraction.timeout
	$"..".is_active = false

func _process(delta):
	var leg_distance = $Line2D.position.distance_to(to_local($RigidBody2D/AttachmentPoint.global_position))
	$Line2D.width = total_width - leg_distance/6
	$Line2D.set_point_position(1, to_local($RigidBody2D/AttachmentPoint.global_position))
