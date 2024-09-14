extends Node2D
@onready var is_painted = false
@onready var has_box = false


func _on_area_2d_area_entered(area):
	if area.is_in_group("splat") and not is_painted:
		is_painted = true
		$PaintDetection.call_deferred("set_monitorable", false)
		$PaintedSquare.visible = true
		get_tree().get_first_node_in_group("paint_tiles").update_paint_percent()


func _process(delta):
	if has_box or not is_painted:
		return
	
	for each in $PlayerDetection.get_overlapping_bodies():
		if each.is_in_group("player"):
			return
	
	has_box = true
	$Platform/PlatformShape2D.call_deferred("set_disabled", false)
