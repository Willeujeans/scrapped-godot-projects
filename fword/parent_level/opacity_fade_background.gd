extends Node2D

@export var layer_count: int = 5
@export var background_opacity_screen: PackedScene
var tile_map_bounds = [0, 0, 0, 0]

func _ready():
	create_opacity_layers()


func create_opacity_layers():
	for each in layer_count:
		var opacity_screen = background_opacity_screen.instantiate()
		opacity_screen.set_z_index(-each)
		add_child(opacity_screen)

