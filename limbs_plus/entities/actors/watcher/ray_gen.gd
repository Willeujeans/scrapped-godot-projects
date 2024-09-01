extends Node2D

@export var line_ray: PackedScene
var ray_count = 90
var width = 10
var rays = []


func _ready():
	generate_rays()


func generate_rays():
	var current_step = 0.0
	for each in ray_count:
		var ray_line_instance = line_ray.instantiate()
		ray_line_instance.get_node("RayCast2D").add_exception(get_parent())
		call_deferred("add_child", ray_line_instance)
		ray_line_instance.rotation = deg_to_rad(current_step)
		current_step += 4.0
