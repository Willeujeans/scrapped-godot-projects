extends Node2D

@export var player_scene: PackedScene

func _ready():
	var player = player_scene.instantiate()
	player.position = global_position
	get_parent().add_child.call_deferred(player)

