extends Sprite2D


func _on_area_2d_body_entered(body):
	if body.is_in_group("stars"):
		body.queue_free()
		scale.x += 0.1
		scale.y += 0.1
		
