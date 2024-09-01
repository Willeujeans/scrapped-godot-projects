extends Node2D
func _ready():
	var player_scene = load("res://player.tscn")
	
	var player_instance = player_scene.instantiate()
	player_instance.position = global_position
	get_parent().add_child.call_deferred(player_instance)
