extends Control
@export var levels: Array[PackedScene]
@export var level_container_scene: PackedScene
var level_elements = []
var elements_random_rotations = []
var elements_random_position = []
var total_stars = 0
var speed = 10.0
var center_index = 0
var can_move_carousell = false


func _ready():
	create_level_containers()
	can_move_carousell = true


func create_level_containers():
	var set_focus = false
	var current_x = 0
	var last_button = null
	var level_index = 0
	
	for each in levels:
		var level_container = level_container_scene.instantiate()
		level_container.set_level(each)
		$Carousell.add_child(level_container)
		level_container.position.x = current_x
		
		current_x += 850
		if not set_focus:
			level_container.get_node("%LevelButton").grab_focus()
			set_focus = true
		
		level_elements.append(level_container)
		create_random_transforms(level_container, current_x)
		level_index += 1
		
	level_elements[0].get_node("%LevelButton").focus_neighbor_left = level_elements[-1].get_node("%LevelButton").get_path()
	level_elements[-1].get_node("%LevelButton").focus_neighbor_right = level_elements[0].get_node("%LevelButton").get_path()
	
	for i in range(len(level_elements)):
		if i - 1 >= 0:
			level_elements[i].get_node("%LevelButton").focus_neighbor_left = level_elements[i - 1].get_node("%LevelButton").get_path()
		if i + 1 < len(level_elements):
			level_elements[i].get_node("%LevelButton").focus_neighbor_right = level_elements[i + 1].get_node("%LevelButton").get_path()
	

func create_random_transforms(level_container, current_x):
	var random_rotation = deg_to_rad(randf_range(-10.0, 10.0))
	var random_position = Vector2(current_x + randf_range(-15.0, 15.0), randf_range(-100.0, 20.0))
	level_container.rotation = random_rotation
	level_container.position = random_position
	elements_random_rotations.append(random_rotation)
	elements_random_position.append(random_position)


func _process(delta):
	if can_move_carousell:
		var center_of_screen = get_viewport().get_visible_rect().size / 2
		var current_center = hover_animation(delta, center_of_screen)
		if current_center != null:
			$Carousell.position.x = lerp($Carousell.position.x, center_of_screen.x - (current_center.position.x + 200), delta * speed)


func hover_animation(delta, center_of_screen):
	var current_center = null
	for i in range(len(level_elements)):
		var level_container = level_elements[i]
		if level_container.get_node("%LevelButton").has_focus():
			current_center = level_container
			center_index = i
			level_container.z_index = 5
			level_container.modulate = lerp(level_container.modulate, Color(1.0,1.0,1.0,1.0), delta * speed)
			level_container.rotation = lerp(level_container.rotation, 0.0, delta * speed)
			level_container.position.y = lerp(level_container.position.y, -100.0, delta * speed)
			level_container.scale = lerp(level_container.scale, Vector2(1.2, 1.2), delta * speed)
		else:
			level_container.modulate = lerp(level_container.modulate, Color(0.6,0.6,0.6,1.0), delta * speed)
			level_container.position = lerp(level_container.position, elements_random_position[i], delta * speed)
			level_container.rotation = lerp(level_container.rotation, elements_random_rotations[i], delta * speed)
			level_container.z_index = 0
			level_container.position.y = lerp(level_container.position.y, 0.0, delta * speed)
			level_container.scale = lerp(level_container.scale, Vector2(1.0, 1.0), delta * speed)
	return current_center
