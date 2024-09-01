extends ColorRect

func _process(delta):
	if $RayCast2D2.is_colliding():
		get_tree().get_first_node_in_group("player").get_node("PlayerCamera").zoom = lerp(get_tree().get_first_node_in_group("player").get_node("PlayerCamera").zoom , Vector2(5.1,5.1),delta)
		get_tree().get_first_node_in_group("key_visible").visible = false

		for each in get_tree().get_nodes_in_group("body_point"):
			each.modulate.a = lerp(each.modulate.a, 3.0, delta)
		color = Color(0.0,1.0,0.0,1.0)

	if !$RayCast2D2.is_colliding():
		get_tree().get_first_node_in_group("player").get_node("PlayerCamera").zoom = lerp(get_tree().get_first_node_in_group("player").get_node("PlayerCamera").zoom , Vector2(5,5),delta)
		get_tree().get_first_node_in_group("key_visible").visible = true

		for each in get_tree().get_nodes_in_group("body_point"):
			each.modulate.a = lerp(each.modulate.a, 0.0, delta)
		color = Color(1.0,0.0,0.0,1.0)


