extends Node2D

signal total_eclipse

func _on_animation_player_animation_finished(anim_name):
	queue_free()


func total_eclipse_occured():
	total_eclipse.emit()
