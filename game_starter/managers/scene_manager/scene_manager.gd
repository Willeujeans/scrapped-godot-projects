extends Node

@export var main_menu_scene: PackedScene
@export var pause_menu_scene: PackedScene
@export var transition_scene: PackedScene

func _ready():
	change_scene(main_menu_scene.instantiate(), false)


func clear_children_UIContainer():
	if $UIContainer.get_children().is_empty():
		return
	for each in $UIContainer.get_children():
		if !each.is_in_group("unclearable"):
			each.queue_free()


func clear_children_ChildContainer():
	if $ChildContainer.get_children().is_empty():
		return
	for each in $ChildContainer.get_children():
		each.queue_free()


func transition(new_scene_instance):
	var transition_instance = transition_scene.instantiate()
	transition_instance.connect("total_eclipse", func(): switch_children(new_scene_instance))
	overlay_ui(transition_instance)


func switch_children(new_scene_instance):
	await clear_children_UIContainer()
	await clear_children_ChildContainer()
	$ChildContainer.call_deferred("add_child", new_scene_instance)


func change_scene(new_scene_instance, with_transition: bool = true):
	if !$ChildContainer.get_children().is_empty():
		print("scene change [" + str($ChildContainer.get_children()[0].name) + "] -> [" + str(new_scene_instance.name) + "]")
	else:
		print("scene change [] -> [" + str(new_scene_instance.name) + "]")
	
	if with_transition:
		transition(new_scene_instance)
	else:
		switch_children(new_scene_instance)


func overlay_ui(new_scene_instance):
	clear_children_UIContainer()
	$UIContainer.call_deferred("add_child", new_scene_instance)

