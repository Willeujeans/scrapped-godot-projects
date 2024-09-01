extends Node2D

func _on_area_2d_body_entered(body):
	if body.is_class("CharacterBody2D"):
		$AnimatedSprite2D.stop()
		$AnimatedSprite2D.play("default")
		body.velocity.y = 0
		if body.is_in_group("player"):
			body.get_node("CoyoteTimer").stop()
		body.velocity.y = -1100

func _on_area_2d_area_shape_entered(area_rid, area, area_shape_index, local_shape_index):
	if area.get_parent().is_in_group("sword"):
		$AnimatedSprite2D.stop()
		$AnimatedSprite2D.play("default")
		#area.get_parent().linear_velocity.y *= -1
		area.get_parent().apply_central_impulse(Vector2(0,-500))
