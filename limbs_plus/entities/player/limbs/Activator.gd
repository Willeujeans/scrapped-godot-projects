extends Node2D
var speed = 1.0
var can_act = false

func set_up():
	$FirstPin.set_node_a($"..".get_parent().get_path())
	$FirstPin.set_node_b($PinPoint.get_path())
	$PinPoint/CollisionShape2D.global_position = $RayCast2D.global_position
	


func activate():
	can_act = true


func _physics_process(delta):
	if can_act:
		$PinPoint/CollisionShape2D.global_position = lerp($PinPoint/CollisionShape2D.global_position, to_global($RayCast2D.target_position), delta)
