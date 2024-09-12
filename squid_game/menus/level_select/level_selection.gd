extends Control
@export var levels: Array[PackedScene]
@export var level_container_scene: PackedScene


func _ready():
	for each in levels:
		var level_container = level_container_scene.instantiate()
		level_container.set_level(each)
		level_container.get_node("SceneChangeNode").current_parent_scene = self.get_path()
		$Carousell.add_child(level_container)
