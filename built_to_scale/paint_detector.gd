extends Node2D
@onready var is_painted = false
@onready var can_create_box = true


func _on_area_2d_area_entered(area):
	if area.is_in_group("splat") and not is_painted:
		is_painted = true
		$Area2D.call_deferred("set_monitorable", false)		
		$ColorRect.visible = true
		get_tree().get_first_node_in_group("paint_tiles").update_paint_percent()
		if can_create_box and $StaticBody2D/CollisionShape2D.disabled:
			$StaticBody2D/CollisionShape2D.call_deferred("set_disabled", false)


func _on_area_2d_body_entered(body):
	if body.is_in_group("player") and is_painted:
		can_create_box = false


func _on_area_2d_body_exited(body):
	if body.is_in_group("player") and not can_create_box and is_painted and $StaticBody2D/CollisionShape2D.disabled:
		$StaticBody2D/CollisionShape2D.call_deferred("set_disabled", false)

