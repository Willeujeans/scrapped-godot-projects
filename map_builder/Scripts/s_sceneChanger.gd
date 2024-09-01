extends Node

func changeSceneTo(target, in_scene):
	print("changing Scene...")
	var instancedScene = in_scene.instantiate()
	for each in target.get_children():
		target.remove_child(each)
		each.queue_free()
	target.add_child(instancedScene)
