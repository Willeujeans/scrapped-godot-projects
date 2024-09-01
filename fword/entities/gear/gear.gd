extends Node2D

@export var clockwise: bool = true
@export var speed: float = 1.1
var is_spinning: bool = true

func _process(delta):
	if is_spinning:
		if clockwise:
			rotation += sin(delta*speed)
		else:
			rotation -= sin(delta*speed)


func _on_area_2d_body_entered(body):
	if body.is_in_group("player"):
		body.kill_self()
