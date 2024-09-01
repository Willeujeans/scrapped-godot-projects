extends CanvasLayer

@export var page_lock: Texture2D
@export var pages: Array[Texture2D]
var is_changing_scene: bool = false


func _ready():
	$ItemList.grab_focus()
	var tracker: int = 0
	var prev_star_count: int = 1
	for level_scene in AllDiscs.get_discs()[AllDiscs.current_disc].levels:
		if level_scene:
			var best_star_count_from_level: int = 0
			var level = level_scene.instantiate()
			var key = level.get_node("SaveNode").get("id")
			var level_data = SaveManager.get_data(key)
			if level_data:
				for each in level_data:
					if each.name == "best_star_count":
						best_star_count_from_level = each.value
			level.queue_free()
			if prev_star_count < 1:
				$ItemList.add_item("", page_lock)
			else:
				$ItemList.add_item("", pages[best_star_count_from_level])
			
			$ItemList.set_item_metadata(tracker, level_scene)
			tracker += 1
			prev_star_count = best_star_count_from_level


func _process(delta):
	if $ItemList.is_anything_selected() and !is_changing_scene:
		is_changing_scene = true
		$SceneChangeNode.next_scene = $ItemList.get_item_metadata($ItemList.get_selected_items()[0])
		if $SceneChangeNode.next_scene:
			print($SceneChangeNode.next_scene)
			$SceneChangeNode.go_next_scene()
