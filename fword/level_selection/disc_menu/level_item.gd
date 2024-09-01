extends Control

@export var level_scene: PackedScene
@export var level_name: String = "level"
var star_count = 0
var level

func _ready():
	if level_scene:
		$SceneChangeNode.next_scene = level_scene
		$SceneChangeNode.current_parent_scene = "../../../../.."
		level = level_scene.instantiate()
		level.visible = false
		get_parent().get_parent().call_deferred("add_child", level)
		star_count = level.get("best_star_count")
		level.queue_free()
	$Label.set_text(level_name)
	var star_text = ""
	for i in star_count:
		star_text += "*"
	$CollectedStars.set_text(star_text)


func _on_button_pressed():
	if level_scene:
		$SceneChangeNode.go_next_scene()
