extends Area2D



func _on_body_entered(body):
	print("in water")
	body.position.y += 10



func _on_body_exited(body):
	print("out water")
	body.position.y -= 10
