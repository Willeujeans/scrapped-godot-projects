extends Node2D


func _on_area_2d_area_entered(area):
	if area.is_in_group("ink"):
		modulate = area.get_parent().modulate
		area.get_parent().fizzle()
