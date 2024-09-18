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
	var set_focus = false
	var current_x = 0
	var last_button = null
	var level_index = 0
	for each in levels:
		var level_container = level_container_scene.instantiate()
		level_container.set_level(each)
		$Carousell.add_child(level_container)
		
		level_container.position.x = current_x
		current_x += 460
		if not set_focus:
			level_container.get_node("Control").get_node("Button").grab_focus()
			set_focus = true
		level_elements.append(level_container)
		var rando_rotation = deg_to_rad(randf_range(-10.0, 10.0))
		var rando_position = Vector2(current_x + randf_range(-15.0, 15.0), randf_range(-100.0, 20.0))
		level_container.rotation = rando_rotation
		level_container.position = rando_position
		elements_random_rotations.append(rando_rotation)
		elements_random_position.append(rando_position)
		level_index += 1
		
	level_elements[0].get_node("Control").get_node("Button").focus_neighbor_left = level_elements[-1].get_node("Control").get_node("Button").get_path()
	level_elements[-1].get_node("Control").get_node("Button").focus_neighbor_right = level_elements[0].get_node("Control").get_node("Button").get_path()
	for i in range(len(level_elements)):
		if i - 1 >= 0:
			level_elements[i].get_node("Control").get_node("Button").focus_neighbor_left = level_elements[i - 1].get_node("Control").get_node("Button").get_path()
		if i + 1 < len(level_elements):
			level_elements[i].get_node("Control").get_node("Button").focus_neighbor_right = level_elements[i + 1].get_node("Control").get_node("Button").get_path()
	can_move_carousell = true


func _process(delta):
	if can_move_carousell:
		flip_input_check()
		var center_of_screen = get_viewport().get_visible_rect().size / 2
		var current_center = hover_animation(delta, center_of_screen)
		if current_center != null:
			$Carousell.position.x = lerp($Carousell.position.x, center_of_screen.x - (current_center.position.x + 200), delta * speed)


func hover_animation(delta, center_of_screen):
	var current_center = null
	for i in range(len(level_elements)):
		if level_elements[i].get_node("Control").get_node("Button").has_focus():
			current_center = level_elements[i]
			center_index = i
			level_elements[i].z_index = 5
			level_elements[i].modulate = lerp(level_elements[i].modulate, Color(1.0,1.0,1.0,1.0), delta * speed)
			level_elements[i].rotation = lerp(level_elements[i].rotation, 0.0, delta * speed)
			level_elements[i].position.y = lerp(level_elements[i].position.y, -100.0, delta * speed)
			level_elements[i].scale = lerp(level_elements[i].scale, Vector2(1.2, 1.2), delta * speed)
		else:
			level_elements[i].modulate = lerp(level_elements[i].modulate, Color(0.6,0.6,0.6,1.0), delta * speed)
			level_elements[i].position = lerp(level_elements[i].position, elements_random_position[i], delta * speed)
			level_elements[i].rotation = lerp(level_elements[i].rotation, elements_random_rotations[i], delta * speed)
			level_elements[i].z_index = 0
			level_elements[i].position.y = lerp(level_elements[i].position.y, 0.0, delta * speed)
			level_elements[i].scale = lerp(level_elements[i].scale, Vector2(1.0, 1.0), delta * speed)
	return current_center


func flip_input_check():
	if Input.is_action_just_pressed("reset"):
		for i in range(len(level_elements)):
			if level_elements[i].get_node("Control").get_node("Button").has_focus():
				level_elements[i].flip()

