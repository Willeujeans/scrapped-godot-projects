extends DampedSpringJoint2D

func _ready():
	set_node_a("../")

func activate():
	stiffness = 20.0
	length = 25
