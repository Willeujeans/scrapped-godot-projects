extends CanvasLayer

signal total_eclipse

func _on_animation_player_animation_finished(anim_name):
	print("removing self")
	queue_free()


func total_eclipse_occured():
	print("eclipse")
	total_eclipse.emit()
