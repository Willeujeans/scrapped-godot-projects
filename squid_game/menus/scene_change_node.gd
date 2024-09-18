extends Node

@export var transition_speed = 1.0
@export var transition_scene: PackedScene
@export var next_scene: PackedScene = load("res://menus/main_menu/main_menu.tscn")
@export var current_parent_scene: NodePath
@export var flag = false

func go_next_scene():
	var transition = transition_scene.instantiate()
	transition.play_speed = transition_speed
	transition.total_eclipse.connect(change_scene)
	get_tree().root.call_deferred("add_child", transition)


func change_scene():
	var next_scene_instance = next_scene.instantiate()
	if "flipped" in next_scene_instance:
		next_scene_instance.flipped = flag
	await get_tree().root.call_deferred("add_child", next_scene_instance)
	get_node(current_parent_scene).queue_free()

