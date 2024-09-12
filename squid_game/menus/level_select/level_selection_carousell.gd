extends Control
@export var levels: Array[PackedScene]
@export var level_container_scene: PackedScene
var level_elements = []


func _ready():
	var set_focus = false
	var current_x = 0
	var last_button = null
	for each in levels:
		var level_container = level_container_scene.instantiate()
		level_container.set_level(each)
		level_container.get_node("SceneChangeNode").current_parent_scene = self.get_path()
		$Carousell.add_child(level_container)
		level_container.position.x = current_x
		current_x += 400
		if not set_focus:
			level_container.get_node("Button").grab_focus()
			set_focus = true
		level_elements.append(level_container)
	
	for i in range(len(level_elements)):
		if i - 1 >= 0:
			level_elements[i].get_node("Button").focus_neighbor_left = level_elements[i - 1].get_node("Button").get_path()
		if i + 1 < len(level_elements):
			level_elements[i].get_node("Button").focus_neighbor_right = level_elements[i + 1].get_node("Button").get_path()

var speed = 2.0
var center_index = 0
func _process(delta):
	var center_of_screen = get_viewport().get_visible_rect().size / 2
	var current_center = null
	for i in range(len(level_elements)):
		if level_elements[i].get_node("Button").has_focus():
			current_center = level_elements[i]
			center_index = i
			level_elements[i].z_index = 5
			level_elements[i].position.y = lerp(level_elements[i].position.y, -50.0, delta * speed)
		else:
			level_elements[i].z_index = 0
			level_elements[i].position.y = lerp(level_elements[i].position.y, 0.0, delta * speed)
	$Carousell.position.x = lerp($Carousell.position.x, center_of_screen.x - (current_center.position.x + 250), delta * speed)
