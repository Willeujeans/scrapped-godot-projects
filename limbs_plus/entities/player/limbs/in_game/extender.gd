extends Node2D
@export var extended_length = 30.0
@export var power = 1.0
@export var foot_scene: PackedScene
@onready var default_rest_length = $DampedSpringJoint2D.get_rest_length()
@onready var default_length = $DampedSpringJoint2D.get_length()
var total_width = 16.0
var collision_line


func set_up():
	$RigidBody2D/CollisionShape2D.set_shape(SegmentShape2D.new())
	$GrooveJoint2D.set_node_a($"..".get_parent().get_path())
	$GrooveJoint2D.set_node_b($RigidBody2D.get_path())
	$DampedSpringJoint2D.set_node_a($"..".get_parent().get_path())
	$DampedSpringJoint2D.set_node_b($RigidBody2D.get_path())


func activate():
	if !$"..".children_limbs.is_empty():
		power += 0.5
	$DampedSpringJoint2D.set_rest_length(extended_length * power)
	$DampedSpringJoint2D.set_length(extended_length)
	$ActivationSound.play()
	$TimeTillRetraction.start()
	await $TimeTillRetraction.timeout
	deactivate()
	


func deactivate():
	$DeactivationSound.play()
	$DampedSpringJoint2D.set_rest_length(default_rest_length)
	$DampedSpringJoint2D.set_length(default_length)
	$Cooldown.start()
	await $Cooldown.timeout
	$"..".is_active = false


func _process(delta):
	$RigidBody2D.center_of_mass = $RigidBody2D/CenterOfMass.position
	$RigidBody2D/CollisionShape2D.shape.a = $RigidBody2D.to_local(global_position)
	$RigidBody2D/CollisionShape2D.shape.b = $RigidBody2D.to_local($RigidBody2D/AttachmentPoint.global_position)
	var leg_distance = $Line2D.position.distance_to(to_local($RigidBody2D/AttachmentPoint.global_position))
	$Line2D.width = total_width - leg_distance/6
	$Line2D.set_point_position(1, to_local($RigidBody2D/AttachmentPoint.global_position))
