extends Node


@export var transition_scene: PackedScene
@export var next_scene: PackedScene = load("res://menus/main_menu/main_menu.tscn")
@export var current_parent_scene: NodePath


func go_next_scene():
	print("transition...")
	var transition = transition_scene.instantiate()
	transition.total_eclipse.connect(change_scene)
	get_tree().root.call_deferred("add_child", transition)


func change_scene():
	await get_tree().root.call_deferred("add_child", next_scene.instantiate())
	get_node(current_parent_scene).queue_free()

