extends Sprite2D

@export var disc1_sprite_list: Array[Texture2D]
@export var disc2_sprite_list: Array[Texture2D]
@export var disc3_sprite_list: Array[Texture2D]
@export var disc4_sprite_list: Array[Texture2D]

func _ready():
	var array = [disc1_sprite_list, disc2_sprite_list, disc3_sprite_list, disc4_sprite_list]
	set_texture(array[AllDiscs.current_disc].pick_random())
