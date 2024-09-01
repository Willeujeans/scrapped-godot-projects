extends CollisionShape2D
var current = 50
var is_extending = false


func _ready():
	$GrooveJoint2D.set_node_a(get_parent().get_path())
	$GrooveJoint2D.set_node_b($GrooveJoint2D/RigidBody2D.get_path())



func _physics_process(delta):
	if is_extending:
		current += 1.0
		$GrooveJoint2D.set_initial_offset(current)


func activate():
	is_extending = true
