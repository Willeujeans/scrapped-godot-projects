extends Node


#func movement():
	#if $"../RayCast2D".is_colliding() || $"../RayCast2D2".is_colliding():
		#flip()
#
#func flip():
	#$"..".direction *= -1
	#$"../RayCast2D".position.x *= -1
	#$"../RayCast2D".target_position.x *= -1
	#$"../RayCast2D2".position.x *= -1
	#$"../RayCast2D2".target_position.x *= -1
	#$"../AnimatedSprite2D".set_flip_h(!$"../AnimatedSprite2D".is_flipped_h())

var lastPosition = Vector2.ZERO

func updateLastPos():
	lastPosition = get_parent().position

func checkStuck():
	var epsilon = 0.05
	if lastPosition <= Vector2(get_parent().position.x + epsilon, get_parent().position.y + epsilon) and lastPosition >= Vector2(get_parent().position.x - epsilon, get_parent().position.y - epsilon):
		$"..".direction *= -1
		$"../AnimatedSprite2D".set_flip_h(!$"../AnimatedSprite2D".is_flipped_h())
