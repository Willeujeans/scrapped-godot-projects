extends Container

@export var dot_image: Texture2D
@export var lilly_pad_image: Texture2D
@export var star_shader: Shader
@export var rigid_form: PackedScene

var is_star: bool = false


func set_star(value: bool):
	is_star = value


func _ready():
	if is_star:
		$Sprite2D.set_texture(lilly_pad_image)


func drop_element():
	var rigid = rigid_form.instantiate()
	var sprite = $Sprite2D
	remove_child(sprite)
	rigid.add_child(sprite)
	rigid.global_position = global_position
	get_parent().get_parent().add_child(rigid)
