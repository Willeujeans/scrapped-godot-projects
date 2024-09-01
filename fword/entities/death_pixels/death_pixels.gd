extends Node2D
var current_cubes: int = 0
var total_cubes: int = 9
var my_material

func _ready():
	var new_parent = get_parent()
	for each in get_children():
		if current_cubes >= total_cubes:
			break
		current_cubes += 1
		each.get_node("ColorRect").set_material(my_material)
		each.set_angular_velocity(randi() % 50)
		var truePosition = each.global_position
		var randoVelocity = Vector2(randi() % 100,-1*(randi() % 500))
		each.set_linear_velocity(randoVelocity)
		self.call_deferred("remove_child", each)
		each.position = truePosition
		new_parent.call_deferred("add_child", each)
	queue_free()
	
func set_my_shader(in_shader):
	my_material = ShaderMaterial.new()
	my_material.set_shader(in_shader)

func set_cube_count(in_int):
	total_cubes = in_int
