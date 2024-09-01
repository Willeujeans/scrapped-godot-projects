extends Area2D

var raise_amount = 256.0/4.0
const water_visual_material = preload("res://inside_water_mat.tres")


func _on_body_entered(body):
	if body.is_class("RigidBody2D"):
		body.set_collision_layer_value(3, false)
		body.set_collision_mask_value(5, true)
	if body.has_node("AnimatedSprite2D"):
		body.get_node("AnimatedSprite2D").set_material(water_visual_material)
		body.get_node("AnimatedSprite2D").position.y += raise_amount
	if body.has_node("Sprite2D"):
		body.get_node("Sprite2D").set_material(water_visual_material)
		body.get_node("Sprite2D").position.y += raise_amount


func _on_body_exited(body):
	if body.has_node("AnimatedSprite2D"):
		body.get_node("AnimatedSprite2D").set_material(null)
		body.get_node("AnimatedSprite2D").position.y -= raise_amount
	if body.has_node("Sprite2D"):
		body.get_node("Sprite2D").set_material(null)
		body.get_node("Sprite2D").position.y -= raise_amount


func _physics_process(delta):
	for each in get_overlapping_bodies():
		if each.is_class("CharacterBody2D"):
			each.position.y += 150.0 * delta
		if each.is_class("RigidBody2D"):
			each.gravity_scale = 1.0
