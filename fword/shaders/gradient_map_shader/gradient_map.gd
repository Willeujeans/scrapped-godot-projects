extends ColorRect

@export var gradient_array: Array[GradientTexture2D] = []

func _ready():
	set_gradient(0)


func set_gradient(i : int):
	get_material().set_shader_parameter("gradient", gradient_array[i])


func set_gradient_with_file(gradient: GradientTexture2D):
	get_material().set_shader_parameter("gradient", gradient)

