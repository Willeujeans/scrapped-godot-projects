extends Area2D
@onready var is_painted = false


func _on_area_entered(area):
	if area.is_in_group("splat"):
		if not is_painted:
			$CollisionShape2D.queue_free()
			is_painted = true
			get_tree().get_first_node_in_group("paint_tiles").update_paint_percent()
