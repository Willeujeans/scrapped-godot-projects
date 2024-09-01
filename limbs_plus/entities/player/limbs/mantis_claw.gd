extends PinJoint2D

func _ready():
	set_node_a("../")
	
func _physics_process(delta):
	print(get_motor_target_velocity())

#func activate():
	#print("jointing")
	#set_motor_target_velocity(deg_to_rad(-200.0))
	#$Timer.start()
	#await $Timer.timeout
	#set_motor_target_velocity(deg_to_rad(0.0))
