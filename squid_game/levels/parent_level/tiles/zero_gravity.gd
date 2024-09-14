extends Node2D


func _ready():
	if randf() > 0.1:
		$CPUParticles2D.visible = false
	$CPUParticles2D.speed_scale = randf_range(0.6,0.8)
	$CPUParticles2D.preprocess = randf_range(2.0,3.5)

func _process(delta):
	for each in $Area2D.get_overlapping_bodies():
		if each.is_class("RigidBody2D"):
			each.apply_central_impulse(Vector2(0,-16))
	for each in $Area2D.get_overlapping_areas():
		if each.is_in_group("ink"):
			each.get_parent().apply_central_impulse(Vector2(0,-20))
