extends Node2D
var current_color : Color

func _ready():
	current_color = $ColorRect.color
	
func _process(delta):
	current_color.a -= 0.08 * delta
	$ColorRect.color = current_color
	$ColorRect2.color = current_color
	if current_color.a <= 0.0:
		queue_free()
